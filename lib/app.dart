import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'l10n/app_translations.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RadioGo',
      theme: AppTheme.darkCyberpunk,
      translations: AppTranslations(),
      locale: const Locale('it', 'IT'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
    );
  }
}
