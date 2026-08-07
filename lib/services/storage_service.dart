import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/radio_station.dart';
import '../utils/constants.dart';

class StorageService {
  // ======================== FAVORITES ========================

  Box get _favorites => Hive.box(AppConstants.favoritesBoxName);

  /// Add a station to favorites (stored by stationuuid).
  void addFavorite(RadioStation station) {
    if (station.stationuuid.isEmpty) return;
    _favorites.put(station.stationuuid, station.toMap());
  }

  /// Remove a station from favorites.
  void removeFavorite(String stationuuid) {
    _favorites.delete(stationuuid);
  }

  /// Get all favorite stations.
  List<RadioStation> getFavorites() {
    final maps = _favorites.values
        .map((v) => v as Map<dynamic, dynamic>)
        .toList();
    return maps
        .map((m) => RadioStation.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  /// Check if a station is a favorite.
  bool isFavorite(String stationuuid) {
    return _favorites.containsKey(stationuuid);
  }

  /// Toggle favorite status. Returns true if added, false if removed.
  bool toggleFavorite(RadioStation station) {
    if (isFavorite(station.stationuuid)) {
      removeFavorite(station.stationuuid);
      return false;
    } else {
      addFavorite(station);
      return true;
    }
  }

  // ======================== RECENT ========================

  Box get _recent => Hive.box(AppConstants.recentBoxName);

  /// Add a station to recent history. Enforces max limit.
  void addRecent(RadioStation station) {
    if (station.stationuuid.isEmpty) return;

    // Remove if already exists (to re-position it at top)
    _recent.delete(station.stationuuid);

    // Trim to max
    while (_recent.length >= AppConstants.maxRecentStations) {
      final keys = _recent.keys.toList();
      if (keys.isNotEmpty) {
        _recent.delete(keys.last);
      }
    }

    _recent.put(station.stationuuid, station.toMap());
  }

  /// Get all recent stations (newest first).
  List<RadioStation> getRecent() {
    final maps = _recent.values
        .map((v) => v as Map<dynamic, dynamic>)
        .toList();
    return maps
        .map((m) => RadioStation.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  /// Clear all recent stations.
  void clearRecent() {
    _recent.clear();
  }

  // ======================== SETTINGS ========================

  Box get _settings => Hive.box(AppConstants.settingsBoxName);

  /// Get a setting value.
  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settings.get(key, defaultValue: defaultValue);
  }

  /// Save a setting value.
  void saveSetting(String key, dynamic value) {
    _settings.put(key, value);
  }

  /// Get saved locale code (e.g., 'it_IT').
  String getLocale() {
    return _settings.get(
      AppConstants.settingsLocaleKey,
      defaultValue: 'it_IT',
    ) as String;
  }

  /// Save locale code.
  void saveLocale(String localeCode) {
    _settings.put(AppConstants.settingsLocaleKey, localeCode);
  }

  /// Get saved theme key.
  String getTheme() {
    return _settings.get(
      AppConstants.settingsThemeKey,
      defaultValue: 'cyberpunk',
    ) as String;
  }

  /// Save theme key.
  void saveTheme(String themeKey) {
    _settings.put(AppConstants.settingsThemeKey, themeKey);
  }

  // ======================== CACHE ========================

  Box get _cache => Hive.box(AppConstants.cacheBoxName);

  /// Store a cached API response with a timestamp.
  void setCache(String key, List<RadioStation> stations) {
    final data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': stations.map((s) => s.toMap()).toList(),
    };
    _cache.put(key, jsonEncode(data));
  }

  /// Get cached data for a key. Returns null if expired or not found.
  List<RadioStation>? getCache(String key) {
    final raw = _cache.get(key);
    if (raw == null) return null;

    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final ttlMs = AppConstants.cacheTtlHours * 60 * 60 * 1000;

      if (now - timestamp > ttlMs) {
        // Cache expired
        _cache.delete(key);
        return null;
      }

      final stationsList = (data['data'] as List)
          .map((m) =>
              RadioStation.fromMap(Map<String, dynamic>.from(m as Map)))
          .toList();
      return stationsList;
    } catch (e) {
      return null;
    }
  }

  /// Check if cache exists and is valid.
  bool hasValidCache(String key) {
    return getCache(key) != null;
  }

  /// Clear all cached data.
  void clearCache() {
    _cache.clear();
  }
}
