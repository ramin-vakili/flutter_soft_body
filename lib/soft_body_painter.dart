import 'package:flutter/material.dart';

import 'models.dart';

/// The [CustomPainter] which paints the soft body consists of points and
/// edges connecting the points on the canvas.
class SoftBodyPainter extends CustomPainter {
  /// Initializes the CustomPainter to paint the graph on the canvas.
  SoftBodyPainter({
    required this.softBody
  })  : _nodePaint = Paint()
          ..color = Colors.blueAccent
          ..style = PaintingStyle.fill
          ..strokeWidth = 1,
        _edgePaint = Paint()
          ..color = Colors.deepOrange
          ..strokeWidth = 3;

  /// List of graph nodes.
  final SoftBody softBody;

  final Paint _nodePaint;
  final Paint _edgePaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final EdgeBase edge in softBody.edges) {
      canvas.drawLine(edge.node1.position, edge.node2.position, _edgePaint);
    }

    for (final MassPoint point in softBody.points) {
      canvas.drawCircle(point.position, point.radius, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
