import 'dart:math';

import 'package:flutter/cupertino.dart';
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
      canvas.save();

      // Define the properties of the rotated rectangle
      Rect rect = Rect.fromCenter(
        center: collider.center,
        width: collider.width,
        height: collider.height,
      );

      double rotationAngle =
          collider.angle * (pi / 180); // Convert degrees to radians

      // Apply a rotation transform to the canvas
      canvas.translate(
        size.width / 2,
        size.height / 2,
      ); // Translate to the center

      canvas.rotate(rotationAngle); // Rotate the canvas

      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
