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
        _createRandomGraph(_graphCanvasSize!);
        setState(() {});
      }
    });
  }

  static const double gy = 0.9;

  void _calculateForces(Size size, Duration elapsedTime) {
    // Gravity
    // for (final MassPoint massPoint in _massPoints) {
    //   final double yForce = gy * massPoint.mass;
    //   massPoint.force = Offset(0, yForce);
    //
    //   massPoint.updatePosition(size: size, elapsedTime: elapsedTime);
    // }

    // // Create force between each pair of nodes
    // for (int i = 0; i < _massPoints.length; i++) {
    //   for (int j = i + 1; j < _massPoints.length; j++) {
    //     final MassPoint node1 = _massPoints[i];
    //     final MassPoint node2 = _massPoints[j];
    //     final direction = node2.position - node1.position;
    //
    //     final Offset forceBetweenTwoNodes =
    //         direction / direction.distanceSquared * 200;
    //
    //     node1.force -= forceBetweenTwoNodes;
    //     node2.force += forceBetweenTwoNodes;
    //
    //     node1.updatePosition(size: _graphCanvasSize!);
    //     node2.updatePosition(size: _graphCanvasSize!);
    //   }
    // }

    for (final ElasticEdge edge2 in _springs) {
      edge2.update(elapsedTime, size);

      edge2.node1.updatePosition(size: size, elapsedTime: elapsedTime);
      edge2.node2.updatePosition(size: size, elapsedTime: elapsedTime);
    }

    // for (final point in _massPoints) {
    //   if (point.position.dy > size.height) {
    //     final distance = point.position.dy - size.height;
    //
    //     point.force -= Offset(0, distance * 10);
    //     point.updatePosition(size: size);
    //   }
    // }
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

  void _createRandomGraph(Size canvasSize) {
    final goo1 = GooBall(30, initialPosition: const Offset(4, 5));
    final goo2 = GooBall(30, initialPosition: const Offset(60, 0));
    final goo3 = GooBall(30, initialPosition: const Offset(120, 10));
    final goo4 = GooBall(30, initialPosition: const Offset(10, 70));
    final goo5 = GooBall(30, initialPosition: const Offset(65, 69));
    final goo6 = GooBall(30, initialPosition: const Offset(132, 76));
    final goo7 = GooBall(30, initialPosition: const Offset(5, 140));
    final goo8 = GooBall(30, initialPosition: const Offset(55, 130));
    final goo9 = GooBall(30, initialPosition: const Offset(100, 120));

    _massPoints.addAll(<MassPoint>[
      goo1,
      goo2,
      // goo3,
      goo4,
      goo5,
      // goo6,
      // goo7,
      // goo8,
      // goo9,
    ]);

    // _springs.addAll([
    //   ElasticEdge(node1: goo1, node2: goo2),
    //   ElasticEdge(node1: goo2, node2: goo3),
    //   ElasticEdge(node1: goo1, node2: goo3),
    // ]);

    _springs.addAll([
      ElasticEdge(node1: goo1, node2: goo2),
      ElasticEdge(node1: goo1, node2: goo4),
      ElasticEdge(node1: goo1, node2: goo5),
      //
      // ElasticEdge(node1: goo2, node2: goo3),
      // ElasticEdge(node1: goo2, node2: goo4),
      ElasticEdge(node1: goo2, node2: goo5),
      // ElasticEdge(node1: goo2, node2: goo6),
      //
      // ElasticEdge(node1: goo3, node2: goo5),
      // ElasticEdge(node1: goo3, node2: goo6),
      //
      ElasticEdge(node1: goo4, node2: goo5),
      // ElasticEdge(node1: goo4, node2: goo7),
      // ElasticEdge(node1: goo4, node2: goo8),
      //
      // ElasticEdge(node1: goo5, node2: goo7),
      // ElasticEdge(node1: goo5, node2: goo8),
      //
      // ElasticEdge(node1: goo7, node2: goo8),
      //
      // ElasticEdge(node1: goo5, node2: goo6),
      // ElasticEdge(node1: goo5, node2: goo7),
      // ElasticEdge(node1: goo5, node2: goo8),
      // ElasticEdge(node1: goo5, node2: goo9),
      //
      // ElasticEdge(node1: goo6, node2: goo8),
      // ElasticEdge(node1: goo6, node2: goo9),
      //
      // ElasticEdge(node1: goo8, node2: goo9),
    ]);
  }
}
