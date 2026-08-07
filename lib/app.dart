import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'l10n/app_translations.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'controllers/settings_controller.dart';
import 'services/log_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // SettingsController is pre-registered in main.dart
    final SettingsController settingsController;
    try {
      settingsController = Get.find<SettingsController>();
    } catch (e) {
      LogService.I.e('App', 'SettingsController not found, using fallback', error: e.toString());
      // Emergency fallback - should never happen
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Color(0xFFFF0040), size: 48),
                const SizedBox(height: 16),
                const Text('Initialization Error',
                  style: TextStyle(color: Color(0xFFFF0040), fontFamily: 'ShareTechMono')),
                const SizedBox(height: 8),
                Text(e.toString(),
                  style: const TextStyle(color: Color(0xFF888888), fontFamily: 'ShareTechMono', fontSize: 12)),
              ],
            ),
          ),
        ),
      );
    }

    return Obx(() {
      return GetMaterialApp(
        title: 'RadioGo',
        theme: AppTheme.fromColors(settingsController.currentTheme.value),
        translations: AppTranslations(),
        locale: settingsController.currentLocale.value,
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.pages,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        onInit: () {
          LogService.I.i('App', 'GetMaterialApp initialized');
        },
      );
    });
  }
}
