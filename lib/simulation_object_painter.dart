import 'package:flutter/material.dart';
import 'package:soft_body/models.dart';

class SimulationObjectPainter extends CustomPainter {
  SimulationObjectPainter(this.object)
      : _paint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.0;

  final SimulationObject object;

  final Paint _paint;

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

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
