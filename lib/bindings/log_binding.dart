import 'package:get/get.dart';
import '../controllers/log_view_controller.dart';
import '../services/log_service.dart';

class LogBinding extends Bindings {
  @override
  void dependencies() {
    final ctrl = LogViewController();
    LogService.I.attachController(ctrl.logController);
    Get.put(ctrl);
  }
}
