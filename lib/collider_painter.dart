import 'package:flutter/material.dart';
import 'package:soft_body/main.dart';
import 'package:soft_body/models.dart';

class ColliderPainter extends CustomPainter {
  ColliderPainter(this.colliders)
      : _paint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill
          ..strokeWidth = 2.0;

  final List<RectangleCollider> colliders;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final RectangleCollider collider in colliders) {
      final Path path = Path();

      // TODO(Ramin): add getPath() method to collider class.
      for (int i = 0; i < collider.edges.length; i++) {
        final ColliderEdge edge = collider.edges[i];
        if (i == 0) {
          path.moveTo(edge.point1.x, edge.point1.y);
        }
        path.lineTo(edge.point2.x, edge.point2.y);
      }

      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
