import 'package:flutter/material.dart';
import 'package:soft_body/models.dart';

class SimulationObjectPainter extends CustomPainter {
  SimulationObjectPainter(this.object)
      : _borderPaint = Paint()
          ..color = Colors.indigo
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
        _fillPaint = Paint()
          ..color = Colors.blueGrey
          ..style = PaintingStyle.fill;

  final SimulationObject object;

  final Paint _borderPaint;
  final Paint _fillPaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (object.orderedPaintingPathPoints.isEmpty ||
        object.orderedPaintingPathPoints.length < 2) {
      return;
    }

    final Path path = Path();

    final Offset firstPoint = object.orderedPaintingPathPoints.first.position;

    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < object.orderedPaintingPathPoints.length; i++) {
      final Offset point = object.orderedPaintingPathPoints[i].position;
      path.lineTo(point.dx, point.dy);
    }

    path.lineTo(firstPoint.dx, firstPoint.dy);

    canvas.drawPath(path, _borderPaint);
    canvas.drawPath(path, _fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
