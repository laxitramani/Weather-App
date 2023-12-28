import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

class MyRoundedRectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.tertiaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width / 2 - 20, 20)
      ..conicTo(size.width / 2, 0, size.width / 2 + 20, 20, 5)
      ..lineTo(size.width - 20, 20)
      ..conicTo(size.width, 20, size.width, 40, 1)
      ..lineTo(size.width, size.height - 20)
      ..conicTo(size.width, size.height, size.width - 20, size.height, 1)
      ..lineTo(20, size.height)
      ..conicTo(0, size.height, 0, size.height - 20, 1)
      ..lineTo(0, 40)
      ..conicTo(0, 20, 20, 20, 1)
      ..lineTo(size.width / 2 - 20, 20);

    canvas.drawPath(path, paint);

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final totalLength = pathMetric.length;
      double distance = 0;

      while (distance < totalLength) {
        final start = pathMetric.getTangentForOffset(distance)!.position;
        distance += 5;
        if (distance > totalLength) {
          distance = totalLength;
        }
        final end = pathMetric.getTangentForOffset(distance)!.position;
        canvas.drawLine(start, end, borderPaint);
        distance += 5;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
