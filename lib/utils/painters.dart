import 'package:flutter/material.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double step = 60.0;
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        Path path = Path();
        path.moveTo(i + step / 2, j);
        path.lineTo(i + step * 0.7, j + step * 0.3);
        path.lineTo(i + step, j + step / 2);
        path.lineTo(i + step * 0.7, j + step * 0.7);
        path.lineTo(i + step / 2, j + step);
        path.lineTo(i + step * 0.3, j + step * 0.7);
        path.lineTo(i, j + step / 2);
        path.lineTo(i + step * 0.3, j + step * 0.3);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
