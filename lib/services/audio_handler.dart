import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/radio_station.dart';
import '../utils/constants.dart';

/// Singleton [RadioGoAudioHandler] used by [audio_service].
/// It bridges just_audio with the system media session (lock-screen, notification).
class RadioGoAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  RadioStation? _currentStation;

  RadioGoAudioHandler() {
    _listenToPlaybackState();
    _listenToProcessingState();
  }

  RadioStation? get currentStation => _currentStation;

  Future<void> playStation(RadioStation station) async {
    _currentStation = station;

    final mediaItem = MediaItem(
      id: station.streamUrl,
      title: station.name,
      artist: station.country,
      artUri: station.favicon.isNotEmpty ? Uri.parse(station.favicon) : null,
      liveStream: true,
    );

    mediaItem.add(mediaItem);
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      processingState: AudioProcessingState.loading,
    ));

    try {
      await _player.setUrl(station.streamUrl);
      await _player.play();
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.error,
      ));
    }
  }

  /// Update the media item title with ICY metadata track title.
  void updateTrackTitle(String title) {
    if (_currentStation == null) return;
    final newMediaItem = MediaItem(
      id: _currentStation!.streamUrl,
      title: title,
      artist: _currentStation!.name,
      artUri: _currentStation!.favicon.isNotEmpty
          ? Uri.parse(_currentStation!.favicon)
          : null,
      liveStream: true,
    );
    mediaItem.add(newMediaItem);
  }

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> skipToNext() async {
    // Not implemented for radio
  }

  @override
  Future<void> skipToPrevious() async {
    // Not implemented for radio
  }

  AudioPlayer get player => _player;

  void _listenToPlaybackState() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: _transformProcessingState(_player.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  AudioProcessingState _transformProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  void _listenToProcessingState() {
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
      }
    });
  }

  /// Parse ICY metadata from the audio stream to extract track title.
  /// This listens to the just_audio player's icy metadata stream.
  Stream<String?> get icyMetadataStream {
    return _player.icyMetadata?.headers?.transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              final title = data['icy-title'];
              if (title != null) {
                sink.add(title as String);
              }
            },
          ),
        ) ??
        const Stream.empty();
  }

  @override
  Future<void> seek(Duration position) async {
    // No seeking in live radio
  }
}
