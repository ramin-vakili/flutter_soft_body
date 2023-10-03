import 'package:flutter/material.dart';
import 'package:soft_body/simulation_object_painter.dart';
import 'package:soft_body/soft_body_painter.dart';

import 'collider_painter.dart';
import 'helpers.dart';
import 'models.dart';

class SimulationScene extends StatefulWidget {
  const SimulationScene({super.key});

  @override
  State<SimulationScene> createState() => _SimulationSceneState();
}

class _SimulationSceneState extends State<SimulationScene>
    with TickerProviderStateMixin {
  static const double gy = 12.8;

  Size? _graphCanvasSize;
  final GlobalKey _canvasKey = GlobalKey();

  MassPoint? _selectedNode;

  late SoftBody _softBody;
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final RenderBox? renderBox =
            _canvasKey.currentContext?.findRenderObject() as RenderBox?;

        if (renderBox != null) {
          _graphCanvasSize = renderBox.size;
          _softBody = generateSampleSoftBody(
            _graphCanvasSize!,
            row: 5,
            column: 4,
            edgeLength: 20,
            position: const Offset(50, 50),
          );
          _colliders.addAll(createRandomColliders(_graphCanvasSize!));

          setState(() {});
        }
      },
    );
  }

  void _calculateForces(Size size, Duration deltaTime) {
    // Gravity
    for (final MassPoint point in _softBody.points) {
      point.force = Offset.zero;
      final double yForce = gy * point.mass;
      point.force += Offset(0, yForce);
    }

    // Spring forces.
    for (final ElasticEdge edge in _softBody.edges) {
      edge.update(deltaTime, size);
    }


    _applyEulerIntegration(deltaTime);
  }

  void _applyEulerIntegration(Duration deltaTime) {
    for (final MassPoint point in _softBody.points) {
      final double adjustedDeltaTime =
          (deltaTime.inMilliseconds / 10000).clamp(0.001, 0.0016);

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

                for (final MassPoint node in _softBody.points) {
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
                    painter: SoftBodyPainter(softBody: _softBody),
                  ),
                  CustomPaint(painter: SimulationObjectPainter(_softBody))
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
