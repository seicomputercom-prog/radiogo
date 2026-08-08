import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/radio_station.dart';
import '../theme/app_colors.dart';
import '../controllers/player_controller.dart';
import '../controllers/settings_controller.dart';

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
  ThemeColors get _tc => Get.find<SettingsController>().currentTheme.value;

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final tc = _tc;
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
          color: _isPressed ? tc.surfaceLight.withAlpha(200) : tc.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying ? tc.accent : tc.divider,
            width: isPlaying ? 1.5 : 1,
          ),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: tc.accent.withAlpha(40),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            _buildFavicon(station.favicon, isPlaying),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: TextStyle(
                      color: tc.textPrimary,
                      fontFamily: 'ShareTechMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (station.country.isNotEmpty) ...[
                        Icon(Icons.location_on, size: 12, color: tc.textSecondary),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            station.country,
                            style: TextStyle(
                              color: tc.textSecondary,
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
                            style: TextStyle(
                              color: tc.textSecondary,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (station.displayBitrate.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tc.accent.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: tc.accentDim, width: 0.5),
                    ),
                    child: Text(
                      station.displayBitrate,
                      style: TextStyle(
                        color: tc.accent,
                        fontFamily: 'ShareTechMono',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (station.displayBitrate.isNotEmpty) const SizedBox(height: 8),
                if (widget.showFavorite)
                  GestureDetector(
                    onTap: widget.onFavoriteTap,
                    child: Icon(
                      Icons.favorite_border,
                      color: tc.textSecondary,
                      size: 20,
                    ),
                  )
                else if (isPlaying)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tc.accent.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: tc.accent, width: 0.5),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        color: tc.accent,
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
    final tc = _tc;
    if (url.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tc.surface,
          border: Border.all(
            color: isPlaying ? tc.accent : tc.divider,
            width: isPlaying ? 2 : 1,
          ),
        ),
        child: Icon(Icons.radio, color: tc.accentDim, size: 24),
      );
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isPlaying ? tc.accent : tc.divider,
          width: isPlaying ? 2 : 1,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: tc.accent.withAlpha(60),
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
            color: tc.surface,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(tc.accentDim),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: tc.surface,
            child: Icon(Icons.radio, color: tc.accentDim, size: 24),
          ),
        ),
      ),
    );
  }
}
