import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/player_controller.dart';
import '../theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/marquee_widget.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();

    return Obx(() {
      final station = playerController.currentStation.value;
      if (station == null) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.accentGreen.withAlpha(100),
              width: 1,
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.player);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Small favicon
                _buildMiniFavicon(station.favicon),
                const SizedBox(width: 12),
                // Station info with marquee
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18,
                        child: SimpleMarquee(
                          text: station.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'ShareTechMono',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        height: 14,
                        child: Obx(() {
                          final title = playerController.nowPlayingTitle.value;
                          final isStillStationName = title == station.name;
                          return SimpleMarquee(
                            text: isStillStationName
                                ? 'live'.tr
                                : title,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'ShareTechMono',
                              fontSize: 11,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Play/Pause button
                GestureDetector(
                  onTap: () => playerController.togglePlayPause(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGreen.withAlpha(20),
                      border: Border.all(
                        color: AppColors.accentGreen,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGreen.withAlpha(40),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Obx(() {
                      return Icon(
                        playerController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: AppColors.accentGreen,
                        size: 22,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMiniFavicon(String url) {
    if (url.isEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceLight,
          border: Border.all(
            color: AppColors.accentGreenDim,
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.radio,
          color: AppColors.accentGreenDim,
          size: 20,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accentGreenDim,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceLight,
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceLight,
            child: const Icon(
              Icons.radio,
              color: AppColors.accentGreenDim,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
