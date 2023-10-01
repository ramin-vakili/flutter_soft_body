import 'package:flutter/material.dart';

import 'collider_painter.dart';
import 'graph_painter.dart';
import 'helpers.dart';
import 'models.dart';

class SimulationScene extends StatefulWidget {
  const SimulationScene({super.key});

  @override
  State<SimulationScene> createState() => _SimulationSceneState();
}

class _SimulationSceneState extends State<SimulationScene>
    with TickerProviderStateMixin {
  static const double gy = 9.8;

  Size? _graphCanvasSize;
  final GlobalKey _canvasKey = GlobalKey();

  MassPoint? _selectedNode;

  final List<MassPoint> _points = <MassPoint>[];
  final List<ElasticEdge> _springs = <ElasticEdge>[];
  final List<RectangleCollider> _colliders = [];

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {});

    _resetGraph();
    _setupTicker();
  }

  Duration? _latestElapsedTime;

  @override
  void didUpdateWidget(covariant SimulationScene oldWidget) {
    super.didUpdateWidget(oldWidget);

    _resetGraph();
  }

  void _setupTicker() {
    createTicker((elapsed) {
      if (_graphCanvasSize != null) {
        Duration? deltaTime;

        if (_latestElapsedTime != null) {
          deltaTime = elapsed - _latestElapsedTime!;
        }
        _latestElapsedTime = elapsed;

        if (deltaTime != null) {
          _calculateForces(_graphCanvasSize!, deltaTime);
        }
      }
      setState(() {});
    }).start();
  }

  void _resetGraph() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _canvasKey.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        _graphCanvasSize = renderBox.size;
        final graph = createRandomGraph(_graphCanvasSize!);
        _points.addAll(graph.$1);
        _springs.addAll(graph.$2);
        _colliders.addAll(createRandomColliders(_graphCanvasSize!));

        setState(() {});
      }
    });
  }

  void _calculateForces(Size size, Duration deltaTime) {
    // Gravity
    for (final MassPoint point in _points) {
      point.force = Offset.zero;
      final double yForce = gy * point.mass;
      point.force += Offset(0, yForce);
    }

    for (final ElasticEdge edge in _springs) {
      edge.update(deltaTime, size);
    }

    for (final MassPoint point in _points) {
      final double adjustedDeltaTime = (deltaTime.inMilliseconds / 10000);

      final dryVelocity =
          point.velocity + point.force * adjustedDeltaTime / point.mass;

      // TODO(Ramin): for performance improvement first check the bounding box of colliders.
      final Offset? collisionPoint = _getCollisionPoint(point, dryVelocity);

      if (collisionPoint != null) {
        final Offset pushVectorNormalized =
            (point.position - collisionPoint).normalized;

        Offset newDryVelocity = (point.velocity -
            pushVectorNormalized *
                2 *
                (point.velocity.dx * pushVectorNormalized.dx +
                    point.velocity.dy * pushVectorNormalized.dy));

        // final Offset collisionImpulse = -dryVelocity * point.mass;
        final Offset collisionImpulse = newDryVelocity * point.mass;
        final Offset collisionForce =
            collisionImpulse / adjustedDeltaTime * 0.3;

        point.force += collisionForce;

        point.velocity = point.force * adjustedDeltaTime / point.mass;

        point.position = collisionPoint +
            (pushVectorNormalized * (point.radius)) +
            point.velocity;
      } else {
        point.velocity += point.force * adjustedDeltaTime / point.mass;
        point.position += point.velocity;
      }
    }
  }

  // TODO(Ramin): check if need handle when a pont collides two colliders at the same time.
  /// Gets the collision point

  Offset? _getCollisionPoint(MassPoint point, Offset dryVelocity) {
    for (final RectangleCollider collider in _colliders) {
      final Offset? collisionPoint = collider.getCollidingPoint(
        point.position + dryVelocity,
        point.radius,
      );

      if (collisionPoint != null) {
        return collisionPoint;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      key: _canvasKey,
      child: _graphCanvasSize != null
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                final Offset mousePos = Offset(
                  details.localPosition.dx,
                  details.localPosition.dy,
                );

                for (final MassPoint node in _points) {
                  final Rect nodeRect = Rect.fromCenter(
                    center: node.position,
                    width: node.mass,
                    height: node.mass,
                  );

                  if (nodeRect.contains(mousePos)) {
                    _selectedNode = node;
                    break;
                  }
                }
              },
              onPanUpdate: (details) {
                if (_selectedNode == null) {
                  return;
                }
                final Offset mousePos = Offset(
                  details.localPosition.dx,
                  details.localPosition.dy,
                );

                _selectedNode!.setPosition = Offset.lerp(
                  _selectedNode!.position,
                  mousePos,
                  0.2,
                )!;
              },
              onPanEnd: (details) {
                _selectedNode = null;
              },
              child: Stack(
                children: [
                  CustomPaint(painter: ColliderPainter(_colliders)),
                  CustomPaint(
                    painter: GraphPainter(
                      points: _points,
                      edges: _springs,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
