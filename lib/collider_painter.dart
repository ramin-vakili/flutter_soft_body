import 'package:flutter/material.dart';
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

    for (final RectangleCollider collider in colliders) {
      for (final ColliderEdge edge in collider.edges) {
        canvas.drawLine(edge.point1, edge.point2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
