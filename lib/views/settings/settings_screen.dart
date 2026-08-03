import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cyberpunk_widgets.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Language section
        _buildSectionHeader('language'.tr),
        _buildLanguageTile(),
        const SizedBox(height: 8),
        // Data section
        _buildSectionHeader('settings'.tr),
        _buildClearRecentTile(),
        _buildClearCacheTile(),
        const SizedBox(height: 8),
        // About section
        _buildSectionHeader('about'.tr),
        _buildAboutTile(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.accentGreenDim,
          fontFamily: 'Orbitron',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildLanguageTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Obx(() {
        return Column(
          children: [
            _languageOption(
              label: 'it'.tr,
              locale: const Locale('it', 'IT'),
              isSelected: controller.isItalian,
              icon: '🇮🇹',
            ),
            const Divider(height: 1, color: AppColors.divider),
            _languageOption(
              label: 'en'.tr,
              locale: const Locale('en', 'US'),
              isSelected: controller.isEnglish,
              icon: '🇬🇧',
            ),
          ],
        );
      }),
    );
  }

  Widget _languageOption({
    required String label,
    required Locale locale,
    required bool isSelected,
    required String icon,
  }) {
    return GestureDetector(
      onTap: () => controller.changeLocale(locale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentGreen.withAlpha(10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.accentGreen
                      : AppColors.textWhite,
                  fontFamily: 'ShareTechMono',
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.accentGreen,
                size: 22,
              )
            else
              const Icon(
                Icons.radio_button_unchecked,
                color: AppColors.textSecondary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearRecentTile() {
    final storage = Get.find<StorageService>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.history,
          color: AppColors.accentGreenDim,
          size: 22,
        ),
        title: Text(
          'clear_recent'.tr,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontFamily: 'ShareTechMono',
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.delete_outline,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onTap: () {
          storage.clearRecent();
          Get.showSnackbar(GetSnackBar(
            message: 'cache_cleared'.tr,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.surface,
            borderColor: AppColors.accentGreen,
            borderWidth: 1,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            snackStyle: SnackStyle.FLOATING,
            messageText: Text(
              'cache_cleared'.tr,
              style: const TextStyle(
                color: AppColors.accentGreen,
                fontFamily: 'ShareTechMono',
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget _buildClearCacheTile() {
    final storage = Get.find<StorageService>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.cleaning_services_outlined,
          color: AppColors.accentGreenDim,
          size: 22,
        ),
        title: Text(
          'clear_cache'.tr,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontFamily: 'ShareTechMono',
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.delete_outline,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onTap: () {
          storage.clearCache();
          Get.showSnackbar(GetSnackBar(
            message: 'cache_cleared'.tr,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.surface,
            borderColor: AppColors.accentGreen,
            borderWidth: 1,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            snackStyle: SnackStyle.FLOATING,
            messageText: Text(
              'cache_cleared'.tr,
              style: const TextStyle(
                color: AppColors.accentGreen,
                fontFamily: 'ShareTechMono',
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget _buildAboutTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.radio,
            color: AppColors.accentGreen,
            size: 40,
          ),
          const SizedBox(height: 12),
          const NeonText(
            text: 'RadioGO',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          const Text(
            'app_subtitle'.tr,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${'version'.tr}: ',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                ),
              ),
              const Text(
                '1.0.0',
                style: TextStyle(
                  color: AppColors.accentGreen,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'API: Radio-Browser.info',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
