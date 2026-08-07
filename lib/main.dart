import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'bindings/initial_binding.dart';
import 'controllers/settings_controller.dart';
import 'services/storage_service.dart';
import 'services/log_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Initialize logging FIRST (catches all subsequent errors)
  final logService = await LogService.init();
  logService.i('Main', 'App starting...');

  try {
    // 2) Hive initialization
    final appDir = await getApplicationDocumentsDirectory();
    logService.i('Main', 'Documents dir: ${appDir.path}');
    await Hive.initFlutter(appDir.path);
    await Hive.openBox('favorites');
    await Hive.openBox('recent');
    await Hive.openBox('settings');
    await Hive.openBox('cache');
    logService.i('Main', 'Hive boxes opened');

    // 3) Pre-register core services BEFORE runApp
    // This fixes the crash where App.build() calls Get.find() before routes.
    Get.put(StorageService(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    logService.i('Main', 'Core services registered');

    // 4) Run app
    runApp(const App());
    logService.i('Main', 'runApp() called');
  } catch (e, st) {
    logService.fatal('Main', 'Failed to start app', error: e.toString(), stackTrace: st.toString());
  }
}
