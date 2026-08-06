import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ======================== MATRIX RAIN PAINTER ========================

/// Custom painter that renders falling green characters (Matrix rain effect).
class MatrixRainPainter extends CustomPainter {
  final int columnCount;
  final double charHeight;
  final Color color;
  final List<int> drops;
  final List<String> chars;

  MatrixRainPainter({
    this.columnCount = 40,
    this.charHeight = 20,
    this.color = AppColors.accentGreen,
    List<int>? drops,
    List<String>? chars,
  })  : drops = drops ?? List.generate(40, (i) => Random().nextInt(30)),
        chars = chars ??
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#\$%^&*(){}[]|;:,.<>?/~`Ω∑∏∫'.split('');

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: color,
      fontSize: charHeight * 0.7,
      fontFamily: 'ShareTechMono',
      fontWeight: FontWeight.normal,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final columnWidth = size.width / columnCount;

    for (int i = 0; i < columnCount; i++) {
      if (drops[i] < 0) continue;

      final x = i * columnWidth;
      final y = drops[i].toDouble() * charHeight;

      if (y < 0 || y > size.height) continue;

      // Draw the character
      final char = chars[Random().nextInt(chars.length)];
      textPainter.text = TextSpan(text: char, style: textStyle);
      textPainter.layout();

      // Vary opacity based on position
      final alpha = (0.8 - (y / size.height) * 0.6).clamp(0.2, 1.0);
      final paint = Paint()..color = color.withAlpha((alpha * 255).round());
      textPainter.paint(canvas, Offset(x, y));

      // Draw a slightly dimmer trail character above
      if (drops[i] > 1) {
        final trailChar = chars[Random().nextInt(chars.length)];
        final trailPainter = TextPainter(
          text: TextSpan(
            text: trailChar,
            style: textStyle.copyWith(
              color: color.withAlpha(80),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        trailPainter.paint(canvas, Offset(x, y - charHeight));
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixRainPainter oldDelegate) => true;
}

// ======================== GLOWING BUTTON ========================

/// A button with a neon green glow/shadow effect.
class GlowingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? glowColor;
  final double glowRadius;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const GlowingButton({
    super.key,
    this.onPressed,
    required this.child,
    this.glowColor,
    this.glowRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? AppColors.accentGreen;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.4,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(60),
                blurRadius: glowRadius,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: color.withAlpha(30),
                blurRadius: glowRadius * 2,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ======================== NEON TEXT ========================

/// Text with a green neon glow using multiple shadows.
class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign textAlign;
  final int? maxLines;

  const NeonText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = 'Orbitron',
    this.textAlign = TextAlign.center,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final glowColor = color ?? AppColors.accentGreen;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: glowColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: 1.5,
        shadows: const [
          Shadow(color: AppColors.accentGreen, blurRadius: 4, offset: Offset(0, 0)),
          Shadow(color: AppColors.accentGreen, blurRadius: 10, offset: Offset(0, 0)),
          Shadow(color: AppColors.accentGreen, blurRadius: 20, offset: Offset(0, 0)),
          Shadow(color: AppColors.accentGreenDim, blurRadius: 30, offset: Offset(0, 0)),
        ],
      ),
    );
  }
}

// ======================== CYBER LOADING INDICATOR ========================

/// A green pulsing loading indicator with cyberpunk styling.
class CyberLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const CyberLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  State<CyberLoadingIndicator> createState() => _CyberLoadingIndicatorState();
}

class _CyberLoadingIndicatorState extends State<CyberLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.accentGreen;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _HexagonPainter(
              color: color,
              progress: _controller.value,
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for a rotating hexagon loading indicator.
class _HexagonPainter extends CustomPainter {
  final Color color;
  final double progress;

  _HexagonPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const sides = 6;

    // Draw rotating hexagon outline
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = SweepGradient(
        colors: [
          color.withAlpha(40),
          color,
          color.withAlpha(40),
        ],
        startAngle: 0,
        endAngle: progress * 2 * pi,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final path = Path();
    for (int i = 0; i <= sides; i++) {
      final angle = (i / sides) * 2 * pi + progress * 2 * pi;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Draw center dot
    canvas.drawCircle(
      center,
      3,
      Paint()
        ..color = color.withAlpha((128 + 127 * sin(progress * 2 * pi)).round().clamp(0, 255)),
    );
  }

  @override
  bool shouldRepaint(covariant _HexagonPainter oldDelegate) => true;
}

// ======================== SCANLINE OVERLAY ========================

/// A subtle CRT scanline overlay for retro effect.
class ScanlineOverlay extends StatelessWidget {
  final Widget child;

  const ScanlineOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          child: CustomPaint(
            painter: _ScanlinePainter(),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0A000000)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) => false;
}

// ======================== MATRIX RAIN ANIMATION WIDGET ========================

/// A full-screen matrix rain animation widget.
class MatrixRainWidget extends StatefulWidget {
  final Widget? child;
  final int columnCount;

  const MatrixRainWidget({
    super.key,
    this.child,
    this.columnCount = 50,
  });

  @override
  State<MatrixRainWidget> createState() => _MatrixRainWidgetState();
}

class _MatrixRainWidgetState extends State<MatrixRainWidget> {
  final List<int> _drops = [];
  final Random _random = Random();
  late int _columnCount;

  @override
  void initState() {
    super.initState();
    _columnCount = widget.columnCount;
    _initDrops();
  }

  void _initDrops() {
    _drops.clear();
    for (int i = 0; i < _columnCount; i++) {
      _drops.add(-_random.nextInt(20));
    }
  }

  void _updateDrops() {
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < _drops.length; i++) {
        if (_drops[i] > 60) {
          _drops[i] = -_random.nextInt(10);
        } else {
          _drops[i] += 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Matrix rain background
        AnimatedBuilder(
          animation: const AlwaysStoppedAnimation(0),
          builder: (context, _) {
            return FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 50), _updateDrops),
              builder: (context, _) {
                return CustomPaint(
                  painter: MatrixRainPainter(
                    columnCount: _columnCount,
                    drops: List.from(_drops),
                    color: AppColors.accentGreen.withAlpha(60),
                    charHeight: 18,
                  ),
                  size: Size.infinite,
                );
              },
            );
          },
        ),
        // Child content
        if (widget.child != null)
          Positioned.fill(
            child: widget.child!,
          ),
      ],
    );
  }
}
