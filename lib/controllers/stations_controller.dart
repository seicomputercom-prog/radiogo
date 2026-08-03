import 'package:get/get.dart';
import '../models/radio_station.dart';
import '../services/radio_browser_service.dart';
import '../services/storage_service.dart';

class StationsController extends GetxController {
  final RadioBrowserService _browserService = Get.find<RadioBrowserService>();
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<RadioStation> allStations = <RadioStation>[].obs;
  final RxList<RadioStation> italianStations = <RadioStation>[].obs;
  final RxList<RadioStation> internationalStations = <RadioStation>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  int _allOffset = 0;
  int _italianOffset = 0;
  int _internationalOffset = 0;
  static const int _pageSize = 30;

  bool _allLoaded = false;
  bool _italianLoaded = false;
  bool _internationalLoaded = false;

  @override
  void onInit() {
    super.onInit();
    loadTopStations();
    loadItalianStations();
    loadInternationalStations();
  }

  /// Load top/popular stations (all).
  Future<void> loadTopStations({bool refresh = false}) async {
    if (refresh) {
      _allOffset = 0;
      _allLoaded = false;
    }

    if (_allLoaded && !refresh) return;

    isLoading.value = true;
    errorMessage.value = '';

    // Check cache
    if (!refresh) {
      final cached = _storageService.getCache('top_stations_$_allOffset');
      if (cached != null && cached.isNotEmpty) {
        allStations.addAll(cached);
        _allOffset += cached.length;
        _allLoaded = cached.length < _pageSize;
        isLoading.value = false;
        return;
      }
    }

    try {
      final stations = await _browserService.getTopStations(
        limit: _pageSize,
        offset: _allOffset,
      );

      if (stations.isEmpty) {
        _allLoaded = true;
      } else {
        if (refresh) {
          allStations.assignAll(stations);
        } else {
          allStations.addAll(stations);
        }
        _allOffset += stations.length;
        _storageService.setCache('top_stations_0', allStations.toList());
      }
    } catch (e) {
      errorMessage.value = 'error_connection'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load Italian stations.
  Future<void> loadItalianStations({bool refresh = false}) async {
    if (refresh) {
      _italianOffset = 0;
      _italianLoaded = false;
    }

    if (_italianLoaded && !refresh) return;

    // Check cache
    if (!refresh) {
      final cached = _storageService.getCache('italian_stations');
      if (cached != null && cached.isNotEmpty) {
        italianStations.assignAll(cached);
        _italianLoaded = true;
        return;
      }
    }

    try {
      final stations = await _browserService.getStationsByCountry(
        countryCode: 'IT',
        limit: _pageSize,
        offset: _italianOffset,
      );

      if (stations.isEmpty) {
        _italianLoaded = true;
      } else {
        italianStations.assignAll(stations);
        _italianOffset += stations.length;
        _storageService.setCache('italian_stations', stations);
      }
    } catch (e) {
      errorMessage.value = 'error_connection'.tr;
    }
  }

  /// Load international stations (non-Italian).
  Future<void> loadInternationalStations({bool refresh = false}) async {
    if (refresh) {
      _internationalOffset = 0;
      _internationalLoaded = false;
    }

    if (_internationalLoaded && !refresh) return;

    // Check cache
    if (!refresh) {
      final cached = _storageService.getCache('international_stations');
      if (cached != null && cached.isNotEmpty) {
        internationalStations.assignAll(cached);
        _internationalLoaded = true;
        return;
      }
    }

    try {
      final stations = await _browserService.searchStations(
        limit: _pageSize,
        offset: _internationalOffset,
      );

      // Filter out Italian stations
      final filtered = stations
          .where((s) => s.countryCode.toUpperCase() != 'IT')
          .toList();

      if (filtered.isEmpty) {
        _internationalLoaded = true;
      } else {
        internationalStations.assignAll(filtered);
        _internationalOffset += _pageSize;
        _storageService.setCache('international_stations', filtered);
      }
    } catch (e) {
      errorMessage.value = 'error_connection'.tr;
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
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more stations for pagination.
  Future<void> loadMoreAll() async {
    if (_allLoaded) return;
    await loadTopStations();
  }

  /// Load more Italian stations.
  Future<void> loadMoreItalian() async {
    if (_italianLoaded) return;
    await loadItalianStations();
  }

  /// Load more international stations.
  Future<void> loadMoreInternational() async {
    if (_internationalLoaded) return;
    await loadInternationalStations();
  }

  /// Refresh all station lists.
  Future<void> refreshAll() async {
    await Future.wait([
      loadTopStations(refresh: true),
      loadItalianStations(refresh: true),
      loadInternationalStations(refresh: true),
    ]);
  }
}
