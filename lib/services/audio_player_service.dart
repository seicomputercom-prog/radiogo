import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import '../models/radio_station.dart';
import '../services/audio_handler.dart';

class AudioPlayerService {
  RadioGoAudioHandler? _audioHandler;

  void init(RadioGoAudioHandler handler) {
    _audioHandler = handler;
  }

  RadioGoAudioHandler get handler {
    if (_audioHandler == null) {
      throw StateError('AudioPlayerService not initialized. Call init() first.');
    }
    return _audioHandler!;
  }

  /// Play a radio station.
  Future<void> play(RadioStation station) async {
    await _audioHandler?.playStation(station);
  }

  /// Pause playback.
  Future<void> pause() async {
    await _audioHandler?.pause();
  }

  /// Stop playback.
  Future<void> stop() async {
    await _audioHandler?.stop();
  }

  /// Resume playback.
  Future<void> resume() async {
    await _audioHandler?.play();
  }

  /// Whether the player is currently playing.
  bool get isPlaying => _audioHandler?.player.playing ?? false;

  /// Player state stream.
  Stream<bool> get isPlayingStream {
    return _audioHandler?.player.playingStream ?? const Stream.empty();
  }

  /// Player processing state stream.
  Stream<Duration> get positionStream {
    return _audioHandler?.player.positionStream ?? const Stream.empty();
  }

  /// Duration stream.
  Stream<Duration?> get durationStream {
    return _audioHandler?.player.durationStream ?? const Stream.empty();
  }

  /// Processing state stream (for loading/buffering indicators).
  Stream<ProcessingState> get processingStateStream {
    return _audioHandler?.player.processingStateStream ?? const Stream.empty();
  }

  /// ICY metadata stream for track title parsing.
  Stream<String?> get icyMetadataStream {
    return _audioHandler?.icyMetadataStream ?? const Stream.empty();
  }

  /// Current station name.
  String get currentStationName =>
      _audioHandler?.currentStation?.name ?? '';

  /// Current station favicon URL.
  String get currentStationFavicon =>
      _audioHandler?.currentStation?.favicon ?? '';

  /// Current station.
  RadioStation? get currentStation => _audioHandler?.currentStation;

  /// Update the track title in the media session (from ICY metadata).
  void updateTrackTitle(String title) {
    _audioHandler?.updateTrackTitle(title);
  }

  void dispose() {
    _audioHandler?.stop();
  }
}
