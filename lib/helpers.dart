import 'dart:math';
import 'dart:ui';

import 'models.dart';

/// Generates some random on random positions inside the [size] area.
List<MassPoint> generateRandomNodes(Size size, {int numberOfNodes = 10}) {
  final List<MassPoint> nodes = <MassPoint>[];

  for (int i = 0; i < numberOfNodes; i++) {
    nodes.add(GooBall(
      _getRandomNodeSize(),
      initialPosition: getRandomPositionInCanvas(size),
    ));
  }

  return nodes;
}

/// Generates some random edges between random node pairs in [nodes] list.
List<EdgeBase> generateRandomEdgesForNodes(List<MassPoint> nodes) {
  final List<EdgeBase> edges = <EdgeBase>[];

  for (int i = 0; i < 20; i++) {
    final (int, int) randomPairs = getRandomEdgePairs(nodes);

    edges.add(ElasticEdge(
      node1: nodes[randomPairs.$1],
      node2: nodes[randomPairs.$2],
    ));
  }

  return edges;
}

/// Generates an [Offset] in random position inside the [size] area.
Offset getRandomPositionInCanvas(Size size) => Offset(
      Random().nextInt(size.width.toInt()).toDouble(),
      Random().nextInt(size.height.toInt()).toDouble(),
    );

double _getRandomNodeSize() => Random().nextInt(5) + 5.0;

/// Generates two int numbers in the range of [nodes] length which in a way
/// that i != j.
(int, int) getRandomEdgePairs(List<MassPoint> nodes) {
  int i = 0, j = 0;
  do {
    final Random random = Random();
    i = random.nextInt(nodes.length);
    j = random.nextInt(nodes.length);
  } while (i == j);

  return (i, j);
}

RectangleCollider createRandomCollider() {
  const Offset topLeft = Offset(0, 300);
  const Offset topRight = Offset(400, 370);
  const Offset bottomLeft = Offset(0, 450);
  const Offset bottomRight = Offset(400, 650);

  final List<Offset> points = <Offset>[
    topLeft,
    topRight,
    bottomLeft,
    bottomRight
  ];

  final List<ColliderEdge> edges = <ColliderEdge>[
    ColliderEdge(topLeft, topRight),
    ColliderEdge(topLeft, bottomLeft),
    ColliderEdge(bottomLeft, bottomRight),
    ColliderEdge(topRight, bottomRight),
  ];

  return RectangleCollider(points: points, edges: edges);
}

(List<MassPoint>, List<ElasticEdge>) createRandomGraph(Size canvasSize) {
  final List<MassPoint> points = <MassPoint>[];
  final List<ElasticEdge> springs = <ElasticEdge>[];

  final goo1 = GooBall(30, initialPosition: const Offset(24, 5));
  final goo2 = GooBall(30, initialPosition: const Offset(80, 0));
  final goo3 = GooBall(30, initialPosition: const Offset(140, 10));
  final goo4 = GooBall(30, initialPosition: const Offset(30, 70));
  final goo5 = GooBall(30, initialPosition: const Offset(85, 69));
  final goo6 = GooBall(30, initialPosition: const Offset(152, 76));
  final goo7 = GooBall(30, initialPosition: const Offset(25, 140));
  final goo8 = GooBall(30, initialPosition: const Offset(75, 130));
  final goo9 = GooBall(30, initialPosition: const Offset(120, 120));

  points.addAll(<MassPoint>[
    goo1,
    goo2,
    goo3,
    goo4,
    goo5,
    goo6,
    goo7,
    goo8,
    goo9,
  ]);

  springs.addAll([
    ElasticEdge(node1: goo1, node2: goo2),
    ElasticEdge(node1: goo1, node2: goo4),
    ElasticEdge(node1: goo1, node2: goo5),
    //
    ElasticEdge(node1: goo2, node2: goo3),
    ElasticEdge(node1: goo2, node2: goo4),
    ElasticEdge(node1: goo2, node2: goo5),
    ElasticEdge(node1: goo2, node2: goo6),
    //
    ElasticEdge(node1: goo3, node2: goo5),
    ElasticEdge(node1: goo3, node2: goo6),
    //
    ElasticEdge(node1: goo4, node2: goo5),
    ElasticEdge(node1: goo4, node2: goo7),
    ElasticEdge(node1: goo4, node2: goo8),
    //
    ElasticEdge(node1: goo5, node2: goo7),
    ElasticEdge(node1: goo5, node2: goo8),
    //
    ElasticEdge(node1: goo7, node2: goo8),
    //
    ElasticEdge(node1: goo5, node2: goo6),
    ElasticEdge(node1: goo5, node2: goo7),
    ElasticEdge(node1: goo5, node2: goo8),
    ElasticEdge(node1: goo5, node2: goo9),
    //
    ElasticEdge(node1: goo6, node2: goo8),
    ElasticEdge(node1: goo6, node2: goo9),
    //
    ElasticEdge(node1: goo8, node2: goo9),
  ]);

  return (points, springs);
}
