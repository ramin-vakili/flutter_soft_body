import 'package:flutter/cupertino.dart';

abstract class MassPoint {
  Offset position;
  Offset velocity;
  Offset force;

  final double mass;

  MassPoint(this.mass, {Offset? initialPosition})
      : position = initialPosition ?? Offset.zero,
        velocity = Offset.zero,
        force = Offset.zero;

  void updatePosition({required Size size}) {
    velocity = force / mass;
    position += velocity;

    position = Offset(
      position.dx.clamp(0, size.width),
      position.dy.clamp(0, size.height),
    );
  }

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
  double ks = 0.8;
  double kd = 8;

  @override
  final MassPoint node1;

  @override
  final MassPoint node2;

  final double length = 60;

  ElasticEdge({required this.node1, required this.node2});

  void update(Duration elapsedTime, Size size) {
    double x1 = node1.position.dx;
    double x2 = node2.position.dx;
    double y1 = node1.position.dy;
    double y2 = node2.position.dy;

    // calculate sqr(distance)
    // double r12d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    double r12d = (node1.position - node2.position).distance;

    if (r12d > 0) {
      // get velocities of start & end points
      double vx12 = node1.velocity.dx - node2.velocity.dx;
      double vy12 = node1.velocity.dy - node2.velocity.dy;
      // calculate force value
      double f = (r12d - length) * ks +
          (vx12 * (x1 - x2) + vy12 * (y1 - y2)) * kd / r12d;

      // force vector
      double fx = ((x1 - x2) / r12d) * f;
      double fy = ((y1 - y2) / r12d) * f;

      node1.force -= Offset(fx, fy);
      node2.force += Offset(fx, fy);
    }

    node1.updatePosition(size: size);
    node2.updatePosition(size: size);
  }
}
