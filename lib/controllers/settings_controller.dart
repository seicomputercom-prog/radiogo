import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../l10n/app_translations.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<Locale> currentLocale = const Locale('it', 'IT').obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// Load saved settings from Hive.
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
  }

  /// Change the app locale.
  void changeLocale(Locale locale) {
    currentLocale.value = locale;
    _storageService.saveLocale('${locale.languageCode}_${locale.countryCode}');

    // Update GetX locale and refresh translations
    final translations = AppTranslations();
    Get.locale = locale;
    // Force translation update
    final newLocale = locale;
    Get.updateLocale(newLocale);
  }

  /// Toggle between Italian and English.
  void toggleLanguage() {
    if (currentLocale.value.languageCode == 'it') {
      changeLocale(const Locale('en', 'US'));
    } else {
      changeLocale(const Locale('it', 'IT'));
    }
  }

  /// Check if current locale is Italian.
  bool get isItalian => currentLocale.value.languageCode == 'it';

  /// Check if current locale is English.
  bool get isEnglish => currentLocale.value.languageCode == 'en';
}
