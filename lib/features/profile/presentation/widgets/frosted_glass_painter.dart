import 'package:flutter/material.dart';

class FrostedGlassPainter extends CustomPainter {
  final double borderRadius;

  FrostedGlassPainter({this.borderRadius = 20.0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );

    // Ana arka plan (koyu ton)
    final backgroundPaint = Paint()..color = const Color(0xFF090909);
    canvas.drawRRect(rrect, backgroundPaint);
    // Üst kırmızı radial gradient
    final topGradientPaint =
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.0, -0.75),
            radius: 1,
            colors: [
              Colors.red.withOpacity(0.5),
              Colors.red.withOpacity(0.25),
              Colors.red.withOpacity(0.08),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 0.5, 0.8],
          ).createShader(
            Rect.fromLTWH(0, -size.height * 0.1, size.width, size.height * 1.2),
          );

    canvas.drawRRect(rrect, topGradientPaint);

    // Alt kırmızı radial gradient
    final bottomGradientPaint =
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.0, 0.75),
            radius: 0.8,
            colors: [
              Colors.red.withOpacity(0.5),
              Colors.red.withOpacity(0.25),
              Colors.red.withOpacity(0.08),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 0.5, 0.8],
          ).createShader(
            Rect.fromLTWH(0, -size.height * 0.1, size.width, size.height * 1.2),
          );

    canvas.drawRRect(rrect, bottomGradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
