import 'package:get/get.dart';
import '../models/radio_station.dart';
import '../services/radio_browser_service.dart';
import '../services/storage_service.dart';
import '../services/log_service.dart';

/// Tracks loading state per category so the UI can show proper feedback.
class _LoadState {
  bool loading = false;
  bool loaded = false;
  bool failed = false;
  String errorMsg = '';
  int offset = 0;
}

class StationsController extends GetxController {
  late final RadioBrowserService _browserService;
  late final StorageService _storageService;

  final RxList<RadioStation> allStations = <RadioStation>[].obs;
  final RxList<RadioStation> italianStations = <RadioStation>[].obs;
  final RxList<RadioStation> internationalStations = <RadioStation>[].obs;

  /// True when at least one category is still loading.
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  static const int _pageSize = 30;

  final _all = _LoadState();
  final _italian = _LoadState();
  final _international = _LoadState();

  bool _anyLoading() => _all.loading || _italian.loading || _international.loading;

  void _refreshIsLoading() => isLoading.value = _anyLoading();

  @override
  void onInit() {
    super.onInit();
    // Use try-catch to avoid crash if services are not yet available
    try {
      _browserService = Get.find<RadioBrowserService>();
      _storageService = Get.find<StorageService>();
    } catch (e) {
      LogService.I.e('Stations', 'Failed to find services in onInit', error: e.toString());
      return;
    }
    LogService.I.i('Stations', 'Controller initialized, loading stations...');
    loadTopStations();
    loadItalianStations();
    loadInternationalStations();
  }

  /// Load top/popular stations (all).
  Future<void> loadTopStations({bool refresh = false}) async {
    if (refresh) {
      _all.offset = 0;
      _all.loaded = false;
      _all.failed = false;
    }
    if (_all.loaded && !refresh) return;

    _all.loading = true;
    _refreshIsLoading();
    errorMessage.value = '';

    // Check cache
    if (!refresh) {
      final cached = _storageService.getCache('top_stations_0');
      if (cached != null && cached.isNotEmpty) {
        allStations.assignAll(cached);
        _all.loaded = true;
        _all.loading = false;
        _refreshIsLoading();
        LogService.I.i('Stations', 'Top stations loaded from cache (${cached.length})');
        return;
      }
    }

    try {
      final stations = await _browserService.getTopStations(
        limit: _pageSize,
        offset: _all.offset,
      );

      if (stations.isEmpty) {
        _all.loaded = true;
        _all.failed = true;
        _all.errorMsg = 'error_connection'.tr;
        if (!_italian.failed && !_international.failed) {
          errorMessage.value = 'error_connection'.tr;
        }
        LogService.I.w('Stations', 'Top stations: empty response from API');
      } else {
        if (refresh) {
          allStations.assignAll(stations);
        } else {
          allStations.addAll(stations);
        }
        _all.offset += stations.length;
        _all.loaded = stations.length < _pageSize;
        _storageService.setCache('top_stations_0', allStations.toList());
        LogService.I.i('Stations', 'Top stations loaded: ${stations.length}');
      }
    } catch (e) {
      _all.failed = true;
      _all.errorMsg = 'error_connection'.tr;
      errorMessage.value = 'error_connection'.tr;
      LogService.I.e('Stations', 'Failed to load top stations', error: e.toString());
    } finally {
      _all.loading = false;
      _refreshIsLoading();
    }
  }

  /// Load Italian stations.
  Future<void> loadItalianStations({bool refresh = false}) async {
    if (refresh) {
      _italian.offset = 0;
      _italian.loaded = false;
      _italian.failed = false;
    }
    if (_italian.loaded && !refresh) return;

    _italian.loading = true;
    _refreshIsLoading();

    // Check cache
    if (!refresh) {
      final cached = _storageService.getCache('italian_stations');
      if (cached != null && cached.isNotEmpty) {
        italianStations.assignAll(cached);
        _italian.loaded = true;
        _italian.loading = false;
        _refreshIsLoading();
        LogService.I.i('Stations', 'Italian stations loaded from cache (${cached.length})');
        return;
      }
    }

    try {
      final stations = await _browserService.getStationsByCountry(
        countryCode: 'IT',
        limit: _pageSize,
        offset: _italian.offset,
      );

      if (stations.isEmpty) {
        _italian.loaded = true;
        _italian.failed = true;
        LogService.I.w('Stations', 'Italian stations: empty response');
      } else {
        italianStations.assignAll(stations);
        _italian.offset += stations.length;
        _italian.loaded = stations.length < _pageSize;
        _storageService.setCache('italian_stations', stations);
        LogService.I.i('Stations', 'Italian stations loaded: ${stations.length}');
      }
    } catch (e) {
      _italian.failed = true;
      LogService.I.e('Stations', 'Failed to load Italian stations', error: e.toString());
    } finally {
      _italian.loading = false;
      _refreshIsLoading();
    }
  }

  /// Load international stations (non-Italian).
  Future<void> loadInternationalStations({bool refresh = false}) async {
    if (refresh) {
      _international.offset = 0;
      _international.loaded = false;
      _international.failed = false;
    }
    if (_international.loaded && !refresh) return;

    _international.loading = true;
    _refreshIsLoading();

    // Check cache
    if (!refresh) {
      final cached = _storageService.getCache('international_stations');
      if (cached != null && cached.isNotEmpty) {
        internationalStations.assignAll(cached);
        _international.loaded = true;
        _international.loading = false;
        _refreshIsLoading();
        LogService.I.i('Stations', 'International stations from cache (${cached.length})');
        return;
      }
    }

    try {
      final stations = await _browserService.searchStations(
        limit: _pageSize,
        offset: _international.offset,
      );

      // Filter out Italian stations
      final filtered =
          stations.where((s) => s.countryCode.toUpperCase() != 'IT').toList();

      if (filtered.isEmpty) {
        _international.loaded = true;
        _international.failed = true;
        LogService.I.w('Stations', 'International stations: empty response');
      } else {
        internationalStations.assignAll(filtered);
        _international.offset += _pageSize;
        _international.loaded = filtered.length < _pageSize;
        _storageService.setCache('international_stations', filtered);
        LogService.I.i('Stations', 'International stations loaded: ${filtered.length}');
      }
    } catch (e) {
      _international.failed = true;
      LogService.I.e('Stations', 'Failed to load international stations', error: e.toString());
    } finally {
      _international.loading = false;
      _refreshIsLoading();
    }
  }

  /// Search stations.
  Future<void> searchStations(String query) async {
    if (query.trim().isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    // Check cache
    final cacheKey = 'search_${query.toLowerCase()}';
    final cached = _storageService.getCache(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      allStations.assignAll(cached);
      isLoading.value = false;
      return;
    }

    try {
      final stations = await _browserService.searchStations(
        query: query,
        limit: _pageSize,
      );
      allStations.assignAll(stations);
      _storageService.setCache(cacheKey, stations);
    } catch (e) {
      errorMessage.value = 'error_connection'.tr;
      LogService.I.e('Stations', 'Search failed for "$query"', error: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more stations for pagination.
  Future<void> loadMoreAll() async {
    if (_all.loaded) return;
    await loadTopStations();
  }

  /// Load more Italian stations.
  Future<void> loadMoreItalian() async {
    if (_italian.loaded) return;
    await loadItalianStations();
  }

  /// Load more international stations.
  Future<void> loadMoreInternational() async {
    if (_international.loaded) return;
    await loadInternationalStations();
  }

  /// Refresh all station lists.
  Future<void> refreshAll() async {
    LogService.I.i('Stations', 'Refreshing all stations...');
    await Future.wait([
      loadTopStations(refresh: true),
      loadItalianStations(refresh: true),
      loadInternationalStations(refresh: true),
    ]);
  }
}
