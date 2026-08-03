import 'package:get/get.dart';
import '../controllers/stations_controller.dart';
import '../controllers/settings_controller.dart';
import '../services/radio_browser_service.dart';
import '../services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StorageService(), fenix: true);
    Get.lazyPut(() => RadioBrowserService(), fenix: true);
    Get.lazyPut(() => StationsController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
