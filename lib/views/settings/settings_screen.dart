import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/settings_controller.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/cyberpunk_widgets.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSectionHeader('language'.tr),
        _buildLanguageTile(),
        const SizedBox(height: 8),
        _buildSectionHeader('themes'.tr),
        _buildThemeTiles(),
        const SizedBox(height: 8),
        _buildSectionHeader('settings'.tr),
        _buildClearRecentTile(),
        _buildClearCacheTile(),
        const SizedBox(height: 8),
        _buildSectionHeader('about'.tr),
        _buildAboutTile(),
        const SizedBox(height: 16),
        _buildCopyrightTile(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: controller.currentTheme.value.accentDim,
          fontFamily: 'Orbitron',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }

  // ==================== LANGUAGE ====================

  Widget _buildLanguageTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: controller.currentTheme.value.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: controller.currentTheme.value.divider),
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
            Divider(height: 1, color: controller.currentTheme.value.divider),
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
              ? controller.currentTheme.value.accent.withAlpha(10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? controller.currentTheme.value.accent
                      : controller.currentTheme.value.textWhite,
                  fontFamily: 'ShareTechMono',
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle,
                  color: controller.currentTheme.value.accent, size: 22)
            else
              Icon(Icons.radio_button_unchecked,
                  color: controller.currentTheme.value.textSecondary,
                  size: 22),
          ],
        ),
      ),
    );
  }

  // ==================== THEMES ====================

  Widget _buildThemeTiles() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: controller.currentTheme.value.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: controller.currentTheme.value.divider),
      ),
      child: Obx(() {
        final current = controller.currentTheme.value;
        return Column(
          children: ThemeColors.all.map((theme) {
            final isSelected = current.key == theme.key;
            return GestureDetector(
              onTap: () => controller.changeTheme(theme),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.accent.withAlpha(10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.accent.withAlpha(40),
                        border: Border.all(color: theme.accent, width: 1.5),
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.accent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        theme.name,
                        style: TextStyle(
                          color: isSelected
                              ? theme.accent
                              : controller.currentTheme.value.textWhite,
                          fontFamily: 'ShareTechMono',
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle,
                          color: theme.accent, size: 20)
                    else
                      Icon(Icons.radio_button_unchecked,
                          color: controller.currentTheme.value.textSecondary,
                          size: 20),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  // ==================== DATA ====================

  Widget _buildClearRecentTile() {
    final storage = Get.find<StorageService>();
    final tc = controller.currentTheme.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: tc.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tc.divider),
      ),
      child: ListTile(
        leading: Icon(Icons.history, color: tc.accentDim, size: 22),
        title: Text(
          'clear_recent'.tr,
          style: TextStyle(
            color: tc.textWhite,
            fontFamily: 'ShareTechMono',
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.delete_outline, color: tc.textSecondary, size: 20),
        onTap: () {
          storage.clearRecent();
          Get.showSnackbar(GetSnackBar(
            message: 'cache_cleared'.tr,
            duration: const Duration(seconds: 2),
            backgroundColor: tc.surface,
            borderColor: tc.accent,
            borderWidth: 1,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            snackStyle: SnackStyle.FLOATING,
            messageText: Text(
              'cache_cleared'.tr,
              style: TextStyle(
                color: tc.accent,
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
    final tc = controller.currentTheme.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: tc.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tc.divider),
      ),
      child: ListTile(
        leading:
            Icon(Icons.cleaning_services_outlined, color: tc.accentDim, size: 22),
        title: Text(
          'clear_cache'.tr,
          style: TextStyle(
            color: tc.textWhite,
            fontFamily: 'ShareTechMono',
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.delete_outline, color: tc.textSecondary, size: 20),
        onTap: () {
          storage.clearCache();
          Get.showSnackbar(GetSnackBar(
            message: 'cache_cleared'.tr,
            duration: const Duration(seconds: 2),
            backgroundColor: tc.surface,
            borderColor: tc.accent,
            borderWidth: 1,
            borderRadius: 8,
            margin: const EdgeInsets.all(16),
            snackStyle: SnackStyle.FLOATING,
            messageText: Text(
              'cache_cleared'.tr,
              style: TextStyle(
                color: tc.accent,
                fontFamily: 'ShareTechMono',
              ),
            ),
          ));
        },
      ),
    );
  }

  // ==================== ABOUT ====================

  Widget _buildAboutTile() {
    final tc = controller.currentTheme.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tc.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tc.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.radio, color: tc.accent, size: 40),
          const SizedBox(height: 12),
          NeonText(text: 'RadioGO', fontSize: 20, fontWeight: FontWeight.bold),
          const SizedBox(height: 4),
          Text(
            'app_subtitle'.tr,
            style: TextStyle(
              color: tc.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: tc.divider),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${'version'.tr}: ',
                style: TextStyle(
                  color: tc.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                ),
              ),
              Text(
                '1.0.0',
                style: TextStyle(
                  color: tc.accent,
                  fontFamily: 'ShareTechMono',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'API: Radio-Browser.info',
            style: TextStyle(
              color: tc.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== COPYRIGHT ====================

  Widget _buildCopyrightTile() {
    final tc = controller.currentTheme.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: tc.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tc.divider),
      ),
      child: Column(
        children: [
          Text(
            AppConstants.copyright,
            style: TextStyle(
              color: tc.textSecondary,
              fontFamily: 'ShareTechMono',
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: AppConstants.websiteUrl,
              style: TextStyle(
                color: tc.accent,
                fontFamily: 'ShareTechMono',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(
                    Uri.parse(AppConstants.websiteUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
}
