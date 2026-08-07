import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/cyberpunk_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _canSkip = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();

    // Allow skip after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _canSkip = true);
    });

    // Auto-navigate after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && !_navigated) _navigate();
    });
  }

  void _navigate() {
    if (_navigated) return;
    _navigated = true;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _MatrixRainBackground(),
          Container(color: AppColors.background.withAlpha(150)),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGreen.withAlpha(15),
                      border: Border.all(
                        color: AppColors.accentGreen.withAlpha(100),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGreen.withAlpha(40),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.radio,
                      color: AppColors.accentGreen,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const NeonText(
                    text: 'RadioGO',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'by infobit.cloud',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'ShareTechMono',
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const CyberLoadingIndicator(size: 30),
                ],
              ),
            ),
          ),
          // Copyright at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _canSkip ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  const Text(
                    '(c) 2025 infobit.cloud',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'ShareTechMono',
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _canSkip ? _navigate : null,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      side: const BorderSide(
                        color: AppColors.accentGreen,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'SKIP >>',
                      style: TextStyle(
                        fontFamily: 'ShareTechMono',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Matrix rain animation for splash screen.
class _MatrixRainBackground extends StatefulWidget {
  @override
  State<_MatrixRainBackground> createState() => _MatrixRainBackgroundState();
}

class _MatrixRainBackgroundState extends State<_MatrixRainBackground> {
  final List<int> _drops = [];
  final Random _random = Random();
  static const int _columns = 40;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _columns; i++) {
      _drops.add(-_random.nextInt(30));
    }
    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      setState(() {
        for (int i = 0; i < _drops.length; i++) {
          if (_drops[i] > 60) {
            _drops[i] = -_random.nextInt(15);
          } else {
            _drops[i] += 1;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MatrixRainPainter(
        columnCount: _columns,
        drops: List.from(_drops),
        color: AppColors.accentGreen.withAlpha(80),
        charHeight: 16,
      ),
      size: Size.infinite,
    );
  }
}
