import 'package:flutter/material.dart';

import 'models.dart';

/// The [CustomPainter] which paints the graph on the canvas.
class GraphPainter extends CustomPainter {
  /// Initializes the CustomPainter to paint the graph on the canvas.
  GraphPainter({
    required this.points,
    required this.edges,
  })  : _nodePaint = Paint()
          ..color = Colors.blueAccent
          ..style = PaintingStyle.fill
          ..strokeWidth = 1,
        _edgePaint = Paint()
          ..color = Colors.deepOrange
          ..strokeWidth = 3;

  /// List of graph nodes.
  final List<MassPoint> points;

  /// List of graph edges.
  final List<EdgeBase> edges;

  final Paint _nodePaint;
  final Paint _edgePaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (final EdgeBase edge in edges) {
      canvas.drawLine(edge.node1.position, edge.node2.position, _edgePaint);
    }

    for (final MassPoint node in points) {
      canvas.drawCircle(node.position, node.radius, _nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
