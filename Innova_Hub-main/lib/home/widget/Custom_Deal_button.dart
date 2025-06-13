


import 'package:flutter/material.dart';

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    // Draw 4 bars with gradient colors
    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.pink,
      Colors.purple,
    ];
    final List<double> heights = [
      size.height * 0.5,
      size.height * 0.8,
      size.height * 0.6,
      size.height * 0.9,
    ];
    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawLine(
        Offset(i * size.width / 4 + 3, size.height),
        Offset(i * size.width / 4 + 3, size.height - heights[i]),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}