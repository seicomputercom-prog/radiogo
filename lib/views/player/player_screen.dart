import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/player_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/radio_station.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/cyberpunk_widgets.dart';
import '../../widgets/marquee_widget.dart';
import '../../utils/constants.dart';

class PlayerScreen extends GetView<PlayerController> {
  const PlayerScreen({super.key});

  ThemeColors get _tc => Get.find<SettingsController>().currentTheme.value;

  @override
  Widget build(BuildContext context) {
    final tc = _tc;
    return Scaffold(
      backgroundColor: tc.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: tc.accent),
        ),
        title: Text(
          'now_playing'.tr,
          style: TextStyle(
            color: tc.accent,
            fontFamily: 'Orbitron',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(color: tc.accent, blurRadius: 8, offset: Offset.zero),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tc.background, tc.accent, tc.background],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final station = controller.currentStation.value;
        if (station == null) return _buildNoStationState();
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                _buildLargeFavicon(station.favicon),
                const SizedBox(height: 32),
                _buildStationName(station.name),
                const SizedBox(height: 8),
                _buildNowPlayingTitle(),
                const SizedBox(height: 24),
                if (controller.isPlaying.value) _buildLiveBadge(),
                if (controller.isPlaying.value) const SizedBox(height: 16),
                _buildStationInfo(station),
                const SizedBox(height: 40),
                _buildPlaybackControls(station),
                const SizedBox(height: 40),
                _buildStatusIndicator(),
                const SizedBox(height: 24),
                _buildCopyright(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNoStationState() {
    final tc = _tc;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.radio, color: tc.accentDim, size: 64),
          const SizedBox(height: 20),
          NeonText(text: 'stations'.tr, fontSize: 20, color: tc.accent),
          const SizedBox(height: 12),
          Text(
            'search_placeholder'.tr,
            style: TextStyle(color: tc.textSecondary, fontFamily: 'ShareTechMono', fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeFavicon(String url) {
    final tc = _tc;
    if (url.isEmpty) {
      return Container(
        width: 200, height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tc.surface,
          border: Border.all(color: tc.accent.withAlpha(100), width: 3),
          boxShadow: [
            BoxShadow(color: tc.accent.withAlpha(30), blurRadius: 30, spreadRadius: 5),
          ],
        ),
        child: Icon(Icons.radio, color: tc.accentDim, size: 80),
      );
    }
    return Container(
      width: 200, height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: tc.accent.withAlpha(120), width: 3),
        boxShadow: [
          BoxShadow(color: tc.accent.withAlpha(40), blurRadius: 30, spreadRadius: 5),
          BoxShadow(color: tc.accent.withAlpha(20), blurRadius: 50, spreadRadius: 10),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url, fit: BoxFit.cover, width: 200, height: 200,
          placeholder: (context, url) => Container(
            color: tc.surface,
            child: Center(child: CyberLoadingIndicator(size: 50, color: tc.accent)),
          ),
          errorWidget: (context, url, error) => Container(
            color: tc.surface,
            child: Icon(Icons.radio, color: tc.accentDim, size: 80),
          ),
        ),
      ),
    );
  }

  Widget _buildStationName(String name) {
    final tc = _tc;
    return SizedBox(
      height: 30,
      child: Center(
        child: SimpleMarquee(
          text: name,
          style: TextStyle(
            color: tc.textPrimary, fontFamily: 'Orbitron', fontSize: 22,
            fontWeight: FontWeight.bold, letterSpacing: 1,
            shadows: [Shadow(color: tc.accent, blurRadius: 10, offset: Offset.zero)],
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlayingTitle() {
    final tc = _tc;
    return Obx(() {
      final title = controller.nowPlayingTitle.value;
      final station = controller.currentStation.value;
      final isStillStationName = station != null && title == station.name;
      return SizedBox(
        height: 22,
        child: Center(
          child: SimpleMarquee(
            text: isStillStationName ? '' : title,
            style: TextStyle(
              color: tc.accent, fontFamily: 'ShareTechMono', fontSize: 14,
              shadows: [Shadow(color: tc.accent, blurRadius: 6, offset: Offset.zero)],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLiveBadge() {
    final tc = _tc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: tc.accent.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tc.accent, width: 1),
            boxShadow: [BoxShadow(color: tc.accent.withAlpha(30), blurRadius: 8)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: tc.accent,
                  boxShadow: [BoxShadow(color: tc.accent, blurRadius: 6)],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'live'.tr,
                style: TextStyle(
                  color: tc.accent, fontFamily: 'Orbitron', fontSize: 11,
                  fontWeight: FontWeight.bold, letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStationInfo(RadioStation station) {
    final tc = _tc;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: tc.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tc.divider, width: 1),
      ),
      child: Column(
        children: [
          if (station.country.isNotEmpty) _infoRow(Icons.location_on, station.country),
          if (station.country.isNotEmpty && station.displayTags.isNotEmpty) const SizedBox(height: 6),
          if (station.displayTags.isNotEmpty) _infoRow(Icons.tag, station.displayTags),
          if ((station.displayTags.isNotEmpty || station.country.isNotEmpty) && station.displayBitrate.isNotEmpty)
            const SizedBox(height: 6),
          if (station.displayBitrate.isNotEmpty) _infoRow(Icons.speed, station.displayBitrate),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    final tc = _tc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: tc.accentDim, size: 16),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: tc.textSecondary, fontFamily: 'ShareTechMono', fontSize: 12)),
      ],
    );
  }

  Widget _buildPlaybackControls(RadioStation station) {
    final storage = Get.find<StorageService>();
    final tc = _tc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(icon: Icons.stop, onTap: () => controller.stop(), size: 50, iconSize: 24, glowIntensity: 0.3, tc: tc),
        const SizedBox(width: 32),
        Obx(() {
          return _controlButton(
            icon: controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
            onTap: () => controller.togglePlayPause(), size: 72, iconSize: 36, glowIntensity: 1.0, tc: tc,
          );
        }),
        const SizedBox(width: 32),
        Obx(() {
          final isFav = storage.isFavorite(station.stationuuid);
          return _controlButton(
            icon: isFav ? Icons.favorite : Icons.favorite_border,
            onTap: () => storage.toggleFavorite(station), size: 50, iconSize: 24, glowIntensity: 0.3,
            iconColor: isFav ? AppColors.errorRed : tc.accent, tc: tc,
          );
        }),
      ],
    );
  }

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
    required double iconSize,
    required double glowIntensity,
    Color? iconColor,
    required ThemeColors tc,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tc.accent.withAlpha(20),
          border: Border.all(
            color: tc.accent.withAlpha((150 * glowIntensity).round().clamp(50, 200)),
            width: glowIntensity > 0.5 ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: tc.accent.withAlpha((80 * glowIntensity).round().clamp(10, 80)),
              blurRadius: (20 * glowIntensity).round().clamp(4, 25).toDouble(),
              spreadRadius: (4 * glowIntensity).round().clamp(0, 6).toDouble(),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? tc.accent, size: iconSize),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final tc = _tc;
    return Obx(() {
      if (controller.isLoading.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 16, height: 16, child: CyberLoadingIndicator(size: 16, color: tc.accent)),
            const SizedBox(width: 8),
            Text('buffering'.tr, style: TextStyle(color: tc.accentDim, fontFamily: 'ShareTechMono', fontSize: 12)),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildCopyright() {
    final tc = _tc;
    return Text(
      AppConstants.copyrightShort,
      style: TextStyle(color: tc.textSecondary, fontFamily: 'ShareTechMono', fontSize: 9, letterSpacing: 0.5),
      textAlign: TextAlign.center,
    );
  }
}
