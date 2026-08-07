import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../l10n/app_translations.dart';
import '../theme/app_colors.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<Locale> currentLocale = const Locale('it', 'IT').obs;
  final Rx<ThemeColors> currentTheme = ThemeColors.cyberpunk.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    final savedLocale = _storageService.getLocale();
    Locale locale;
    if (savedLocale == 'en_US') {
      locale = const Locale('en', 'US');
    } else {
      locale = const Locale('it', 'IT');
    }
    currentLocale.value = locale;
    Get.updateLocale(locale);

    final savedTheme = _storageService.getTheme();
    currentTheme.value = ThemeColors.fromKey(savedTheme);
  }

  void changeLocale(Locale locale) {
    currentLocale.value = locale;
    _storageService.saveLocale(
        '${locale.languageCode}_${locale.countryCode}');
    final newLocale = locale;
    Get.updateLocale(newLocale);
  }

  void changeTheme(ThemeColors theme) {
    currentTheme.value = theme;
    _storageService.saveTheme(theme.key);
  }

  bool get isItalian => currentLocale.value.languageCode == 'it';
  bool get isEnglish => currentLocale.value.languageCode == 'en';

  void toggleLanguage() {
    if (currentLocale.value.languageCode == 'it') {
      changeLocale(const Locale('en', 'US'));
    } else {
      changeLocale(const Locale('it', 'IT'));
    }
  }
}