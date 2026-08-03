import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/player_controller.dart';
import '../../services/storage_service.dart';
import '../../models/radio_station.dart';
import '../../theme/app_colors.dart';
import '../../widgets/station_card.dart';
import '../../widgets/cyberpunk_widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final StorageService _storage = Get.find<StorageService>();
  final RxList<RadioStation> favorites = <RadioStation>[].obs;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    favorites.assignAll(_storage.getFavorites());
  }

  void _removeFavorite(RadioStation station) {
    _storage.removeFavorite(station.stationuuid);
    favorites.remove(station);

    Get.showSnackbar(GetSnackBar(
      message: 'fav_removed'.tr,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.surface,
      borderColor: AppColors.errorRed,
      borderWidth: 1,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        'fav_removed'.tr,
        style: const TextStyle(
          color: AppColors.errorRed,
          fontFamily: 'ShareTechMono',
        ),
      ),
    ));
  }

  void _playStation(RadioStation station) {
    final playerController = Get.find<PlayerController>();
    playerController.playStation(station);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (favorites.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        color: AppColors.accentGreen,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          _loadFavorites();
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(favorites[index].stationuuid),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _removeFavorite(favorites[index]),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.errorRed,
                  size: 28,
                ),
              ),
              child: StationCard(
                station: favorites[index],
                onTap: () => _playStation(favorites[index]),
                onFavoriteTap: () => _removeFavorite(favorites[index]),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
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
              Icons.favorite_border,
              color: AppColors.accentGreenDim,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          NeonText(
            text: 'no_favorites'.tr,
            fontSize: 18,
          ),
          const SizedBox(height: 12),
          Text(
            'add_favorite'.tr,
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
}
