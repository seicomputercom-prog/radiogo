import 'package:get/get.dart';
import '../controllers/stations_controller.dart';
import '../controllers/settings_controller.dart';
import '../services/radio_browser_service.dart';
import '../services/storage_service.dart';
import '../services/log_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // StorageService and SettingsController are already permanent in main.dart
    // Only register services that are NOT already registered
    if (!Get.isRegistered<RadioBrowserService>()) {
      Get.lazyPut(() => RadioBrowserService(), fenix: true);
    }
    if (!Get.isRegistered<StationsController>()) {
      Get.lazyPut(() => StationsController(), fenix: true);
    }
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut(() => SettingsController(), fenix: true);
    }
    if (!Get.isRegistered<StorageService>()) {
      Get.lazyPut(() => StorageService(), fenix: true);
    }
    LogService.I.i('Binding', 'InitialBinding applied');
  }
}
