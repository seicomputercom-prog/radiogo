import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/player_controller.dart';
import '../../models/radio_station.dart';
import '../../theme/app_colors.dart';
import '../../widgets/station_card.dart';
import '../../widgets/cyberpunk_widgets.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        _buildSearchBar(),
        // Results
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.onSearchChanged,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'ShareTechMono',
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'search_placeholder'.tr,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.accentGreenDim,
                  size: 20,
                ),
                suffixIcon: Obx(() {
                  if (controller.searchQuery.value.isNotEmpty) {
                    return GestureDetector(
                      onTap: controller.clearSearch,
                      child: const Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
              cursorColor: AppColors.accentGreen,
              textInputAction: TextInputAction.search,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Obx(() {
      final isSearching = controller.isSearching.value;
      final hasResults = controller.searchResults.isNotEmpty;
      final noResults = controller.noResults.value;
      final query = controller.searchQuery.value;

      // Initial state - no query entered
      if (query.isEmpty && !isSearching) {
        return _buildInitialState();
      }

      // Searching
      if (isSearching) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CyberLoadingIndicator(size: 36),
              const SizedBox(height: 16),
              Text(
                'search'.tr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }

      // No results
      if (noResults) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off,
                color: AppColors.accentGreenDim,
                size: 48,
              ),
              const SizedBox(height: 16),
              NeonText(
                text: 'no_results'.tr,
                fontSize: 18,
              ),
              const SizedBox(height: 8),
              Text(
                '"${controller.searchQuery.value}"',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }

      // Results list
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

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentGreen.withAlpha(10),
              border: Border.all(
                color: AppColors.accentGreenDim.withAlpha(80),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.accentGreenDim,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          NeonText(
            text: 'search'.tr,
            fontSize: 20,
          ),
          const SizedBox(height: 8),
          Text(
            'search_placeholder'.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
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
