import 'package:flutter/material.dart';

class ColliderEdge {
  ColliderEdge(this.point1, this.point2);

  final Offset point1;
  final Offset point2;
}

class RectangleCollider {
  RectangleCollider({required this.points, required this.edges});

  final List<Offset> points;

  final List<ColliderEdge> edges;

  bool isPointInside(Offset point) {
    int numberOfIntersections = 0;
    for (final ColliderEdge edge in edges) {
      if (doLinesIntersect(
        point,
        Offset(point.dx, 100000),
        edge.point1,
        edge.point2,
      )) {
        numberOfIntersections++;
      }
    }

    return numberOfIntersections.isOdd;
  }

  static bool doLinesIntersect(
    Offset line1Start,
    Offset line1End,
    Offset line2Start,
    Offset line2End,
  ) {
    Offset dir1 = Offset(line1End.x - line1Start.x, line1End.y - line1Start.y);
    Offset dir2 = Offset(line2End.x - line2Start.x, line2End.y - line2Start.y);

    // Calculate determinant to check if lines are parallel
    double det = dir1.x * dir2.y - dir1.y * dir2.x;

    // Check if lines are parallel (det == 0)
    if (det == 0) {
      return false;
    }

    // Calculate parameters for the parametric equations of the lines
    double t1 = ((line2Start.x - line1Start.x) * dir2.y -
            (line2Start.y - line1Start.y) * dir2.x) /
        det;
    double t2 = ((line2Start.x - line1Start.x) * dir1.y -
            (line2Start.y - line1Start.y) * dir1.x) /
        det;

    // Check if the intersection point is within the line segments
    if (t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1) {
      return true; // Lines intersect within line segments
    }

    return false;
  }
}

extension OffsetExtension on Offset {
  double get x => dx;

  double get y => dy;
}

abstract class MassPoint {
  Offset position;
  Offset velocity;
  Offset force;
  final double radius;

  final double mass;

  MassPoint(this.mass, {Offset? initialPosition, this.radius = 10})
      : position = initialPosition ?? Offset.zero,
        velocity = Offset.zero,
        force = Offset.zero;

  set setPosition(Offset newPosition) {
    position = newPosition;
  }
}

/// A Goo ball.
class GooBall extends MassPoint {
  GooBall(super.mass, {super.initialPosition});
}

abstract class EdgeBase {
  MassPoint get node1;

  MassPoint get node2;
}

/// A connection between two nodes/particle, joint, which has elastic behaviour.
class ElasticEdge implements EdgeBase {
  double ks = 200;
  double kd = 1200;

  @override
  final MassPoint node1;

  @override
  final MassPoint node2;

  final double length = 55;

  ElasticEdge({required this.node1, required this.node2});

  void update(Duration elapsedTime, Size size) {
    double x1 = node1.position.dx;
    double x2 = node2.position.dx;
    double y1 = node1.position.dy;
    double y2 = node2.position.dy;

    // calculate sqr(distance)
    double distanceSquared = (node1.position - node2.position).distance;

    if (distanceSquared > 0) {
      // get velocities of start & end points
      double vx12 = node1.velocity.dx - node2.velocity.dx;
      double vy12 = node1.velocity.dy - node2.velocity.dy;

      final double stifnessForce = (distanceSquared - length) * ks;
      final double dampingForce =
          (vx12 * (x1 - x2) + vy12 * (y1 - y2)) * kd / distanceSquared;

      // calculate force value
      double f = stifnessForce + dampingForce;

      // force vector
      double fx = ((x1 - x2) / distanceSquared) * f;
      double fy = ((y1 - y2) / distanceSquared) * f;

      Offset newForce = Offset(fx, fy);

      node1.force -= newForce;
      node2.force += newForce;
    }
  }
}
