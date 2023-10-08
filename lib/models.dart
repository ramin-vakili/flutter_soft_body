import 'package:flutter/material.dart';
import 'package:soft_body/extensions.dart';

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

  static Offset findIntersectionPoint(
      Offset point, Offset lineStart, Offset lineEnd) {
    double dxLine = lineEnd.x - lineStart.x;
    double dyLine = lineEnd.y - lineStart.y;

    // Calculate the vector from line's start point to point
    double dxVector = point.x - lineStart.x;
    double dyVector = point.y - lineStart.y;

    // Calculate the projection of vector AP onto vector B
    double t = (dxVector * dxLine + dyVector * dyLine) /
        (dxLine * dxLine + dyLine * dyLine);

    // Ensure the parameter t is within the bounds of the line segment
    t = t.clamp(0.0, 1.0);

    // Calculate the closest point on line
    double xClosest = lineStart.x + t * dxLine;
    double yClosest = lineStart.y + t * dyLine;

    return Offset(xClosest, yClosest);
  }

  /// Returns the colliding point if the [ballCenter] colliding this collider.
  ///
  /// Returns null if not colliding.
  Offset? getCollidingPoint(Offset ballCenter, double ballRadius) {
    for (final ColliderEdge edge in edges) {
      final Offset endOfTheLineFromCenterOfBallToEdge =
          findIntersectionPoint(ballCenter, edge.point1, edge.point2);

      final Offset directionFromCenterToEdge =
          endOfTheLineFromCenterOfBallToEdge - ballCenter;

      final Offset hittingPoint =
          ballCenter + directionFromCenterToEdge.normalized * ballRadius;

      if (isPointInside(hittingPoint)) {
        final List<Offset> intersectionPoints = [];
        for (final ColliderEdge edge in edges) {
          intersectionPoints.add(
              findIntersectionPoint(hittingPoint, edge.point1, edge.point2));
        }

        return intersectionPoints.reduce((point1, point2) =>
            (hittingPoint - point1).distance < (hittingPoint - point2).distance
                ? point1
                : point2);
      }
    }
    return null;
  }
}


abstract class SimulationObject {
  List<MassPoint> get orderedPaintingPathPoints;
}

class SoftBody implements SimulationObject {
  final List<MassPoint> points;
  final List<Spring> springs;
  final List<MassPoint> paintingPathPoints;

  SoftBody(this.points, this.springs, this.paintingPathPoints);

  @override
  List<MassPoint> get orderedPaintingPathPoints => paintingPathPoints;
}

/// A mass point in the simulation which represents an object with mass,
/// velocity, force, etc.
class MassPoint {
  Offset position;
  Offset velocity;
  Offset force;
  final double radius;

  final double mass;

  MassPoint({this.mass = 30, Offset? initialPosition, this.radius = 3})
      : position = initialPosition ?? Offset.zero,
        velocity = Offset.zero,
        force = Offset.zero;
}

/// An edge which connects two [MassPoint]s.
abstract class EdgeBase {
  MassPoint get point1;

  MassPoint get point2;
}

/// A connection between two nodes/particle, joint, which has elastic behaviour.
class Spring implements EdgeBase {
  static const double ks = 510;
  static const double kd = 2100;

  @override
  final MassPoint point1;

  @override
  final MassPoint point2;

  final double restLength;

  Spring({required this.point1, required this.point2, this.restLength = 30});

  /// Applies the spring forces to the [point1] and [point2].
  void update() {
    double x1 = point1.position.dx;
    double x2 = point2.position.dx;
    double y1 = point1.position.dy;
    double y2 = point2.position.dy;

    // calculate sqr(distance)
    double distanceSquared = (point1.position - point2.position).distance;

    if (distanceSquared > 0) {
      // get velocities of start & end points
      double vx12 = point1.velocity.dx - point2.velocity.dx;
      double vy12 = point1.velocity.dy - point2.velocity.dy;

      final double stiffnessForce =
          double.parse(((distanceSquared - restLength) * ks).toStringAsFixed(10));
      final double dampingForce =
          (vx12 * (x1 - x2) + vy12 * (y1 - y2)) * kd / distanceSquared;

      // calculate force value
      double f = stiffnessForce + dampingForce;

      // force vector
      double fx = ((x1 - x2) / distanceSquared) * f;
      double fy = ((y1 - y2) / distanceSquared) * f;

      Offset newForce = Offset(fx, fy);

      point1.force -= newForce;
      point2.force += newForce;
    }
  }
}
