import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/radio_station.dart';
import '../services/audio_player_service.dart';
import '../services/audio_handler.dart';
import '../services/log_service.dart';
import '../services/storage_service.dart';
import '../services/radio_browser_service.dart';
import '../utils/constants.dart';

class PlayerController extends GetxController {
  late final AudioPlayerService _audioService;
  late final StorageService _storageService;

  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<RadioStation?> currentStation = Rx<RadioStation?>(null);
  final RxString nowPlayingTitle = ''.obs;

  StreamSubscription? _playingSubscription;
  StreamSubscription? _processingSubscription;
  StreamSubscription? _icySubscription;

  @override
  void onInit() {
    super.onInit();
    try {
      _audioService = Get.find<AudioPlayerService>();
      _storageService = Get.find<StorageService>();
    } catch (e) {
      LogService.I.e('Player', 'Failed to find services in onInit', error: e.toString());
      return;
    }
    _initAudioService();
  }

  void _initAudioService() {
    try {
      final handler = Get.find<RadioGoAudioHandler>();
      _audioService.init(handler);
      _listenToStreams();
      LogService.I.i('Player', 'Audio service initialized');
    } catch (e) {
      LogService.I.w('Player', 'Audio handler not ready yet', error: e.toString());
    }
  }

  void _listenToStreams() {
    _playingSubscription?.cancel();
    _processingSubscription?.cancel();
    _icySubscription?.cancel();

    _playingSubscription = _audioService.isPlayingStream.listen((playing) {
      isPlaying.value = playing;
    });

    _processingSubscription =
        _audioService.processingStateStream.listen((state) {
      isLoading.value = state == ProcessingState.loading ||
          state == ProcessingState.buffering;
    });

    _icySubscription = _audioService.icyMetadataStream.listen((title) {
      if (title != null && title.isNotEmpty) {
        final cleanTitle = _parseIcyTitle(title);
        nowPlayingTitle.value = cleanTitle;
        _audioService.updateTrackTitle(cleanTitle);
        LogService.I.d('Player', 'ICY: $cleanTitle');
      }
    });
  }

  /// Parse ICY metadata title, removing common prefixes.
  String _parseIcyTitle(String raw) {
    // ICY titles often come as "StreamTitle='Artist - Title'"
    String cleaned = raw;
    if (cleaned.startsWith("StreamTitle='") && cleaned.endsWith("'")) {
      cleaned = cleaned.substring(13, cleaned.length - 1);
    } else if (cleaned.startsWith('StreamTitle="') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(13, cleaned.length - 1);
    }
    // Remove common prefixes
    for (final prefix in ['StreamTitle:', 'Title:', 'Artist - ']) {
      if (cleaned.startsWith(prefix)) {
        cleaned = cleaned.substring(prefix.length).trim();
      }
    }
    return cleaned.trim();
  }

  /// Play a radio station.
  Future<void> playStation(RadioStation station) async {
    LogService.I.i('Player', 'Playing: ${station.name}');
    try {
      isLoading.value = true;
      currentStation.value = station;
      nowPlayingTitle.value = station.name;

      await _audioService.play(station);
      LogService.I.i('Player', 'Stream started: ${station.urlResolved}');

      _storageService.addRecent(station);

      try {
        final browserService = Get.find<RadioBrowserService>();
        await browserService.clickStation(station.stationuuid);
      } catch (_) {}
    } catch (e, st) {
      isLoading.value = false;
      isPlaying.value = false;
      LogService.I.e('Player', 'Failed to play ${station.name}', error: e.toString(), stackTrace: st.toString());
    }
  }

  /// Toggle play/pause.
  Future<void> togglePlayPause() async {
    if (isPlaying.value) {
      await _audioService.pause();
    } else {
      await _audioService.resume();
    }
  }

  /// Stop playback.
  Future<void> stop() async {
    await _audioService.stop();
    isPlaying.value = false;
    isLoading.value = false;
    nowPlayingTitle.value = '';
    currentStation.value = null;
  }

  /// Check if a station is currently playing.
  bool isCurrentStation(RadioStation station) {
    return currentStation.value?.stationuuid == station.stationuuid;
  }

  @override
  void onClose() {
    _playingSubscription?.cancel();
    _processingSubscription?.cancel();
    _icySubscription?.cancel();
    super.onClose();
  }
}
