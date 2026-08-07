import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'l10n/app_translations.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'controllers/settings_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
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
      );
    });
  }
}
