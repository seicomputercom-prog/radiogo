import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main_controller.dart';
import '../../controllers/player_controller.dart';
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
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'RadioGO',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: AppColors.accentGreen,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'app_subtitle'.tr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.radio,
                  color: AppColors.accentGreen,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Main content area
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
            // Mini player above bottom nav
            const MiniPlayer(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      );
    });
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBg,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.bottomNavBg,
          selectedItemColor: AppColors.accentGreen,
          unselectedItemColor: AppColors.textSecondary,
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
