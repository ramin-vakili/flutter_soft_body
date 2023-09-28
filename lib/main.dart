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

  final List<MassPoint> _massPoints = <MassPoint>[];
  final List<ElasticEdge> _springs = <ElasticEdge>[];

  @override
  void initState() {
    super.initState();
    createTicker((elapsed) {});

    _resetGraph();
    _setupTicker();
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    _resetGraph();
  }

  void _setupTicker() {
    createTicker((elapsed) {
      if (_graphCanvasSize != null) {
        _calculateForces(_graphCanvasSize!, elapsed);
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
        _massPoints.addAll(graph.$1);
        _springs.addAll(graph.$2);

        setState(() {});
      }
    });
  }

  static const double gy = 9.8;

  void _calculateForces(Size size, Duration elapsedTime) {
    // Gravity
    // for (final MassPoint massPoint in _massPoints) {
    //   final double yForce = gy * massPoint.mass;
    //   massPoint.force = Offset(0, yForce);
    //
    //   massPoint.updatePosition(size: size, elapsedTime: elapsedTime);
    // }


    for (final ElasticEdge edge2 in _springs) {
      edge2.update(elapsedTime, size);

      edge2.node1.updatePosition(size: size, elapsedTime: elapsedTime);
      edge2.node2.updatePosition(size: size, elapsedTime: elapsedTime);
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

                    for (final MassPoint node in _massPoints) {
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
                      nodes: _massPoints,
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
