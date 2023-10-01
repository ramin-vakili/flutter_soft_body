import 'package:flutter/material.dart';
import 'package:soft_body/main.dart';
import 'package:soft_body/models.dart';

class ColliderPainter extends CustomPainter {
  ColliderPainter(this.colliders)
      : _paint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

  final List<RectangleCollider> colliders;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final RectangleCollider collider in colliders) {
      for (final ColliderEdge edge in collider.edges) {
        canvas.drawLine(edge.point1, edge.point2, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
