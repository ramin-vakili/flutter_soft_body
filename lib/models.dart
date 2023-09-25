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

  void updatePosition({required Offset force, required Size size}) {
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

/// A connection between two nodes/particle, joint, which has elastic behaviour.
class ElasticEdge implements EdgeBase {
  double ks = 0.5;
  Offset l0 = const Offset(10, 10);
  Offset kd = const Offset(5, 5);

  final double length;

  late Offset normalVector;

  @override
  final MassPoint node1;

  @override
  final MassPoint node2;

  ElasticEdge({required this.node1, required this.node2, required this.length});

  void update(Duration elapsedTime, Size size) {}
}

/// A Goo ball.
class GooBall extends MassPoint {
  GooBall(super.mass, {super.initialPosition});
}

/// A node of the graph.
class Node extends MassPoint {
  Node(super.mass, {super.initialPosition});
}

abstract class EdgeBase {
  MassPoint get node1;

  MassPoint get node2;
}

/// The edge in the graph which connects two nodes.
class Edge implements EdgeBase {
  @override
  final Node node1;

  @override
  final Node node2;

  /// The length of this edge.
  final double distance;

  Edge(this.node1, this.node2, this.distance);
}

/// A building consists of goo balls stick together in a graph shape structure.
///
/// *-----*
///  \   / \
///   \ /   \
///    *-----*
class GooStructure extends MassPoint {
  GooStructure(super.mass, {super.initialPosition});
}
