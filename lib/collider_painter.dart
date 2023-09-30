import 'package:flutter/material.dart';
import 'package:soft_body/main.dart';
import 'package:soft_body/models.dart';

class ColliderPainter extends CustomPainter {
  ColliderPainter(this.colliders);

  final List<RectangleCollider> colliders;

  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object to define the rectangle's appearance
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Paint collisionPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final RectangleCollider collider in colliders) {
      for (final ColliderEdge edge in collider.edges) {
        canvas.drawLine(edge.point1, edge.point2, paint);
      }
    }

    canvas.drawCircle(Offset.zero, 1, paint);

    if (pushVector != null) {
      canvas.drawCircle(pushVector!, 1, collisionPaint);
    }

    if (hitPosition != null) {
      canvas.drawCircle(
          hitPosition!,
          1,
          Paint()
            ..color = Colors.purpleAccent
            ..strokeWidth = 1..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
