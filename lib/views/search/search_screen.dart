import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/player_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/radio_station.dart';
import '../../theme/app_colors.dart';
import '../../widgets/station_card.dart';
import '../../widgets/cyberpunk_widgets.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  ThemeColors get _tc => Get.find<SettingsController>().currentTheme.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildSearchBar() {
    final tc = _tc;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.onSearchChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                color: tc.textPrimary,
                fontFamily: 'ShareTechMono',
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'search_placeholder'.tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: tc.accentDim,
                  size: 20,
                ),
                suffixIcon: Obx(() {
                  if (controller.searchQuery.value.isNotEmpty) {
                    return GestureDetector(
                      onTap: controller.clearSearch,
                      child: Icon(
                        Icons.clear,
                        color: tc.textSecondary,
                        size: 20,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Obx(() {
      final tc = _tc;
      final isSearching = controller.isSearching.value;
      final noResults = controller.noResults.value;
      final query = controller.searchQuery.value;

      if (query.isEmpty && !isSearching) {
        return _buildInitialState(tc);
      }

      if (isSearching) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CyberLoadingIndicator(size: 36, color: tc.accent),
              const SizedBox(height: 16),
              Text(
                'search'.tr,
                style: TextStyle(
                  color: tc.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }

      if (noResults) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                color: tc.accentDim,
                size: 48,
              ),
              const SizedBox(height: 16),
              NeonText(
                text: 'no_results'.tr,
                fontSize: 18,
                color: tc.accent,
              ),
              const SizedBox(height: 8),
              Text(
                '"${controller.searchQuery.value}"',
                style: TextStyle(
                  color: tc.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final station = controller.searchResults[index];
          return StationCard(
            station: station,
            onTap: () => _playStation(station),
          );
        },
      );
    });
  }

  Widget _buildInitialState(ThemeColors tc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tc.accent.withAlpha(10),
              border: Border.all(
                color: tc.accentDim.withAlpha(80),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.search,
              color: tc.accentDim,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          NeonText(
            text: 'search'.tr,
            fontSize: 20,
            color: tc.accent,
          ),
          const SizedBox(height: 8),
          Text(
            'search_placeholder'.tr,
            style: TextStyle(
              color: tc.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _playStation(RadioStation station) {
    final playerController = Get.find<PlayerController>();
    playerController.playStation(station);
  }
}
