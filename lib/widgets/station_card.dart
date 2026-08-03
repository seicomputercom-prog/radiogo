import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/radio_station.dart';
import '../theme/app_colors.dart';
import '../controllers/player_controller.dart';

class StationCard extends StatefulWidget {
  final RadioStation station;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool showFavorite;

  const StationCard({
    super.key,
    required this.station,
    this.onTap,
    this.onFavoriteTap,
    this.showFavorite = true,
  });

  @override
  State<StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final isPlaying = Get.find<PlayerController>().isCurrentStation(station);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isPressed
              ? AppColors.surfaceLight.withAlpha(200)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying
                ? AppColors.accentGreen
                : AppColors.divider,
            width: isPlaying ? 1.5 : 1,
          ),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: AppColors.accentGreen.withAlpha(40),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Favicon
            _buildFavicon(station.favicon, isPlaying),
            const SizedBox(width: 12),
            // Station info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Station name
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'ShareTechMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Country + Genre
                  Row(
                    children: [
                      if (station.country.isNotEmpty) ...[
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            station.country,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'ShareTechMono',
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (station.country.isNotEmpty && station.displayTags.isNotEmpty)
                        const SizedBox(width: 8),
                      if (station.displayTags.isNotEmpty)
                        Flexible(
                          child: Text(
                            station.displayTags,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'ShareTechMono',
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Right side: bitrate + favorite
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (station.displayBitrate.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.accentGreenDim,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      station.displayBitrate,
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontFamily: 'ShareTechMono',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (station.displayBitrate.isNotEmpty)
                  const SizedBox(height: 8),
                if (widget.showFavorite)
                  GestureDetector(
                    onTap: widget.onFavoriteTap,
                    child: Obx(() {
                      final storage = Get.find<PlayerController>();
                      final isFav = false; // Check will be done by parent
                      return Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav
                            ? AppColors.errorRed
                            : AppColors.textSecondary,
                        size: 20,
                      );
                    }),
                  )
                else if (isPlaying)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.accentGreen,
                        width: 0.5,
                      ),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: AppColors.accentGreen,
                        fontFamily: 'ShareTechMono',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavicon(String url, bool isPlaying) {
    if (url.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(
            color: isPlaying ? AppColors.accentGreen : AppColors.divider,
            width: isPlaying ? 2 : 1,
          ),
        ),
        child: const Icon(
          Icons.radio,
          color: AppColors.accentGreenDim,
          size: 24,
        ),
      );
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isPlaying ? AppColors.accentGreen : AppColors.divider,
          width: isPlaying ? 2 : 1,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: AppColors.accentGreen.withAlpha(60),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          placeholder: (context, url) => Container(
            color: AppColors.surface,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accentGreenDim,
                  ),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surface,
            child: const Icon(
              Icons.radio,
              color: AppColors.accentGreenDim,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
