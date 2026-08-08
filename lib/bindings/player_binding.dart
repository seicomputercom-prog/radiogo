import 'package:get/get.dart';
import '../controllers/player_controller.dart';
import '../services/audio_player_service.dart';
import '../services/audio_handler.dart';
import '../services/log_service.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    // MainController and SearchController are already registered in InitialBinding
    if (!Get.isRegistered<RadioGoAudioHandler>()) {
      Get.lazyPut(() => RadioGoAudioHandler(), fenix: true);
    }
    if (!Get.isRegistered<AudioPlayerService>()) {
      Get.lazyPut(() => AudioPlayerService(), fenix: true);
    }
    if (!Get.isRegistered<PlayerController>()) {
      Get.lazyPut(() => PlayerController(), fenix: true);
    }
    LogService.I.i('Binding', 'PlayerBinding applied');
  }
}
