import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/player_controller.dart';
import '../controllers/settings_controller.dart';
import '../theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../widgets/marquee_widget.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  ThemeColors get _tc => Get.find<SettingsController>().currentTheme.value;

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();

    return Obx(() {
      final station = playerController.currentStation.value;
      if (station == null) return const SizedBox.shrink();
      final tc = _tc;

      return Container(
        decoration: BoxDecoration(
          color: tc.surface,
          border: Border(
            top: BorderSide(color: tc.accent.withAlpha(100), width: 1),
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
                _buildMiniFavicon(station.favicon, tc),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18,
                        child: SimpleMarquee(
                          text: station.name,
                          style: TextStyle(
                            color: tc.textPrimary,
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
                            text: isStillStationName ? 'live'.tr : title,
                            style: TextStyle(
                              color: tc.textSecondary,
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
                GestureDetector(
                  onTap: () => playerController.togglePlayPause(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tc.accent.withAlpha(20),
                      border: Border.all(color: tc.accent, width: 1.5),
                      boxShadow: [
                        BoxShadow(color: tc.accent.withAlpha(40), blurRadius: 8),
                      ],
                    ),
                    child: Obx(() {
                      return Icon(
                        playerController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                        color: tc.accent,
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

  Widget _buildMiniFavicon(String url, ThemeColors tc) {
    if (url.isEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tc.surfaceLight,
          border: Border.all(color: tc.accentDim, width: 1),
        ),
        child: Icon(Icons.radio, color: tc.accentDim, size: 20),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: tc.accentDim, width: 1),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          placeholder: (context, url) => Container(color: tc.surfaceLight),
          errorWidget: (context, url, error) => Container(
            color: tc.surfaceLight,
            child: Icon(Icons.radio, color: tc.accentDim, size: 20),
          ),
        ),
      ),
    );
  }
}
