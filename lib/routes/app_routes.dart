import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../bindings/player_binding.dart';
import '../bindings/log_binding.dart';
import '../views/splash/splash_screen.dart';
import '../views/home/home_screen.dart';
import '../views/stations/stations_screen.dart';
import '../views/search/search_screen.dart';
import '../views/favorites/favorites_screen.dart';
import '../views/settings/settings_screen.dart';
import '../views/player/player_screen.dart';
import '../views/logs/log_viewer_screen.dart';

abstract class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const stations = '/stations';
  static const search = '/search';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const player = '/player';
  static const logs = '/logs';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: PlayerBinding(),
    ),
    GetPage(name: stations, page: () => StationsScreen()),
    GetPage(name: search, page: () => const SearchScreen()),
    GetPage(name: favorites, page: () => const FavoritesScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: player, page: () => const PlayerScreen()),
    GetPage(
      name: logs,
      page: () => const LogViewerScreen(),
      binding: LogBinding(),
    ),
  ];
}