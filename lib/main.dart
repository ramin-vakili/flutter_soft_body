import 'package:flutter/material.dart';

import 'graph_painter.dart';
import 'helpers.dart';
import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Size? _graphCanvasSize;
  final GlobalKey _canvasKey = GlobalKey();

  MassPoint? _selectedNode;

  final List<MassPoint> _points = <MassPoint>[];
  final List<ElasticEdge> _springs = <ElasticEdge>[];

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {});

    _resetGraph();
    _setupTicker();
  }

  Duration? _latestElapsedTime;

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
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

        setState(() {});
      }
    });
  }

  static const double gy = 9.8;

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

      if ((point.position + dryVelocity).dy + point.radius > size.height) {
        final Offset collisionImpulse = -dryVelocity * point.mass;
        final Offset collisionForce = collisionImpulse / adjustedDeltaTime;

        point.force += collisionForce;

        point.velocity += point.force * adjustedDeltaTime / point.mass;

        final double x = point.position.dx + point.velocity.dx;
        final double y = size.height - point.radius;

        point.position = Offset(x, y);
      } else {
        point.velocity += point.force * adjustedDeltaTime / point.mass;
        point.position += point.velocity;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          key: _canvasKey,
          child: _graphCanvasSize != null
              ? GestureDetector(
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
                  child: CustomPaint(
                    painter: GraphPainter(
                      nodes: _points,
                      edges: _springs,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
