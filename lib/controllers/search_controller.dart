import 'dart:async';
import 'package:get/get.dart';
import '../models/radio_station.dart';
import '../services/radio_browser_service.dart';

class SearchController extends GetxController {
  final RadioBrowserService _browserService = Get.find<RadioBrowserService>();

  final RxString searchQuery = ''.obs;
  final RxList<RadioStation> searchResults = <RadioStation>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool noResults = false.obs;

  Timer? _debounceTimer;
  static const int _debounceMs = 500;
  static const int _resultLimit = 50;

  /// Called when search query changes. Debounces by 500ms.
  void onSearchChanged(String query) {
    searchQuery.value = query;

    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      searchResults.clear();
      noResults.value = false;
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    noResults.value = false;

    _debounceTimer = Timer(Duration(milliseconds: _debounceMs), () {
      _performSearch(query.trim());
    });
  }

  /// Perform the actual search.
  Future<void> _performSearch(String query) async {
    isSearching.value = true;
    noResults.value = false;

    try {
      final stations = await _browserService.searchStations(
        query: query,
        limit: _resultLimit,
        offset: 0,
      );

      searchResults.assignAll(stations);
      noResults.value = stations.isEmpty;
    } catch (e) {
      searchResults.clear();
      noResults.value = true;
    } finally {
      isSearching.value = false;
    }
  }

  /// Clear search.
  void clearSearch() {
    _debounceTimer?.cancel();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
    noResults.value = false;
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
