import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/stations_controller.dart';
import '../../controllers/player_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../services/storage_service.dart';
import '../../models/radio_station.dart';
import '../../theme/app_colors.dart';
import '../../widgets/station_card.dart';
import '../../widgets/cyberpunk_widgets.dart';

class StationsScreen extends StatelessWidget {
  StationsScreen({super.key});

  final RxInt selectedFilter = 0.obs;

  ThemeColors get _tc => Get.find<SettingsController>().currentTheme.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(child: _buildStationList()),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() {
        final tc = _tc;
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _filterChip('all_stations'.tr, 0, tc),
            _filterChip('italian_stations'.tr, 1, tc),
            _filterChip('international_stations'.tr, 2, tc),
            _filterChip('popular'.tr, 3, tc),
          ],
        );
      }),
    );
  }

  Widget _filterChip(String label, int index, ThemeColors tc) {
    return GestureDetector(
      onTap: () => selectedFilter.value = index,
      child: Obx(() {
        final selected = selectedFilter.value == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? tc.accent.withAlpha(30)
                : tc.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? tc.accent : tc.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? tc.accent : tc.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStationList() {
    final controller = Get.find<StationsController>();

    return Obx(() {
      final tc = _tc;
      final isLoadingVal =
          controller.isLoading.value && _getStations(controller).isEmpty;
      final stations = _getStations(controller);
      final hasError = controller.errorMessage.value.isNotEmpty;

      if (isLoadingVal) {
        return _buildLoadingShimmer(tc);
      }

      if (hasError && stations.isEmpty) {
        return _buildErrorState(tc, controller);
      }

      if (stations.isEmpty) {
        return _buildEmptyState(tc);
      }

      return RefreshIndicator(
        color: tc.accent,
        backgroundColor: tc.surface,
        onRefresh: () async {
          await controller.refreshAll();
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: stations.length,
          itemBuilder: (context, index) {
            return StationCard(
              station: stations[index],
              onTap: () => _playStation(stations[index]),
              onFavoriteTap: () => _toggleFavorite(stations[index]),
            );
          },
        ),
      );
    });
  }

  List<RadioStation> _getStations(StationsController controller) {
    switch (selectedFilter.value) {
      case 1:
        return controller.italianStations;
      case 2:
        return controller.internationalStations;
      case 3:
        return controller.allStations.take(20).toList();
      default:
        return controller.allStations;
    }
  }

  void _playStation(RadioStation station) {
    final playerController = Get.find<PlayerController>();
    playerController.playStation(station);
  }

  void _toggleFavorite(RadioStation station) {
    final storage = Get.find<StorageService>();
    final tc = _tc;
    final added = storage.toggleFavorite(station);
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: tc.surface,
      borderColor: added ? tc.accent : AppColors.errorRed,
      borderWidth: 1,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        added ? 'fav_added'.tr : 'fav_removed'.tr,
        style: TextStyle(
          color: added ? tc.accent : AppColors.errorRed,
          fontFamily: 'ShareTechMono',
        ),
      ),
    ));
  }

  Widget _buildLoadingShimmer(ThemeColors tc) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _ShimmerCard(
          delay: Duration(milliseconds: index * 100),
          tc: tc,
        );
      },
    );
  }

  Widget _buildErrorState(ThemeColors tc, StationsController controller) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, color: AppColors.errorRed, size: 48),
          const SizedBox(height: 16),
          NeonText(
            text: 'error_connection'.tr,
            fontSize: 16,
            color: AppColors.errorRed,
          ),
          const SizedBox(height: 8),
          Text(
            'connection_error'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tc.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          GlowingButton(
            onPressed: () => controller.refreshAll(),
            child: Text(
              'retry'.tr,
              style: TextStyle(
                color: tc.accent,
                fontFamily: 'ShareTechMono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeColors tc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.radio, color: tc.accentDim, size: 64),
          const SizedBox(height: 16),
          NeonText(text: 'no_results'.tr, fontSize: 16, color: tc.accent),
          const SizedBox(height: 8),
          Text(
            'connection_error'.tr,
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
}

/// A simple shimmer card for loading state.
class _ShimmerCard extends StatefulWidget {
  final Duration delay;
  final ThemeColors tc;

  const _ShimmerCard({required this.delay, required this.tc});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tc = widget.tc;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = (_controller.value * 2 - 1).abs();
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: tc.cardBg
                .withAlpha((180 + (75 * value)).round().clamp(180, 255)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tc.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tc.surfaceLight
                      .withAlpha((180 + (75 * value)).round().clamp(180, 255)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: tc.surfaceLight.withAlpha(
                            (180 + (75 * value)).round().clamp(180, 255)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 120,
                      decoration: BoxDecoration(
                        color: tc.surfaceLight.withAlpha(
                            (180 + (75 * value)).round().clamp(180, 255)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
