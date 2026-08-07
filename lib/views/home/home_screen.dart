import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/mini_player.dart';
import '../../views/stations/stations_screen.dart';
import '../../views/search/search_screen.dart';
import '../../views/favorites/favorites_screen.dart';
import '../../views/settings/settings_screen.dart';

class HomeScreen extends GetView<MainController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCtrl = Get.find<SettingsController>();
    return Obx(() {
      final tc = settingsCtrl.currentTheme.value;
      return Scaffold(
        backgroundColor: tc.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'RadioGO',
                style: TextStyle(
                  color: tc.textPrimary,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: tc.accent,
                      blurRadius: 10,
                      offset: Offset.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'app_subtitle'.tr,
                style: TextStyle(
                  color: tc.textSecondary,
                  fontFamily: 'ShareTechMono',
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.player),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.radio, color: tc.accent, size: 24),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: controller.currentIndex.value,
                children: [
                  StationsScreen(),
                  SearchScreen(),
                  FavoritesScreen(),
                  SettingsScreen(),
                ],
              ),
            ),
            const MiniPlayer(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(tc),
      );
    });
  }

  Widget _buildBottomNav(ThemeColors tc) {
    return Container(
      decoration: BoxDecoration(
        color: tc.bottomNavBg,
        border: Border(top: BorderSide(color: tc.divider, width: 1)),
      ),
      child: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: tc.bottomNavBg,
          selectedItemColor: tc.accent,
          unselectedItemColor: tc.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'ShareTechMono',
            fontSize: 10,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'ShareTechMono',
            fontSize: 10,
            letterSpacing: 0.5,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.radio, size: 22),
              label: 'stations'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search, size: 22),
              label: 'search'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite, size: 22),
              label: 'favorites'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings, size: 22),
              label: 'settings'.tr,
            ),
          ],
        );
      }),
    );
  }
}
