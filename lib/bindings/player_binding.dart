import 'package:get/get.dart';
import '../controllers/player_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/search_controller.dart';
import '../services/audio_player_service.dart';
import '../services/audio_handler.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RadioGoAudioHandler(), fenix: true);
    Get.lazyPut(() => AudioPlayerService(), fenix: true);
    Get.lazyPut(() => PlayerController(), fenix: true);
    Get.lazyPut(() => MainController(), fenix: true);
    Get.lazyPut(() => SearchController(), fenix: true);
  }
}
