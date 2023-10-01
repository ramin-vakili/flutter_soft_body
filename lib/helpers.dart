import 'dart:math';
import 'dart:ui';

import 'models.dart';

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

List<RectangleCollider> createRandomColliders(Size size) {
  const Offset topLeft = Offset(0, 200);
  const Offset topRight = Offset(200, 270);
  const Offset bottomLeft = Offset(0, 300);
  const Offset bottomRight = Offset(200, 300);

  final List<Offset> points = <Offset>[
    topLeft,
    topRight,
    bottomLeft,
    bottomRight
  ];

  final List<ColliderEdge> edges = <ColliderEdge>[
    ColliderEdge(topLeft, topRight),
    ColliderEdge(topRight, bottomRight),
    ColliderEdge(bottomRight, bottomLeft),
    ColliderEdge(bottomLeft, topLeft),
  ];

  final Offset groundTopLeft = Offset(0, size.height - 10);
  final Offset groundTopRight = Offset(size.width, size.height - 10);
  final Offset groundBottomRight = Offset(size.width, size.height);
  final Offset groundBottomLeft = Offset(0, size.height);

  final RectangleCollider ground = RectangleCollider(points: [
    groundTopLeft,
    groundTopRight,
    groundBottomRight,
    groundBottomLeft
  ], edges: [
    ColliderEdge(groundTopLeft, groundTopRight),
    ColliderEdge(groundTopRight, groundBottomRight),
    ColliderEdge(groundBottomRight, groundBottomLeft),
    ColliderEdge(groundBottomLeft, groundTopLeft),
  ]);

  return [
    RectangleCollider(points: points, edges: edges),
    ground,
  ];
}

(List<MassPoint>, List<ElasticEdge>) createRandomGraph(Size canvasSize) {
  final List<MassPoint> points = <MassPoint>[];
  final List<ElasticEdge> springs = <ElasticEdge>[];

  final goo1 = MassPoint(initialPosition: const Offset(24, 5));
  final goo2 = MassPoint(initialPosition: const Offset(80, 0));
  final goo3 = MassPoint(initialPosition: const Offset(140, 10));
  final goo4 = MassPoint(initialPosition: const Offset(30, 70));
  final goo5 = MassPoint(initialPosition: const Offset(85, 69));
  final goo6 = MassPoint(initialPosition: const Offset(152, 76));
  final goo7 = MassPoint(initialPosition: const Offset(25, 140));
  final goo8 = MassPoint(initialPosition: const Offset(75, 130));
  final goo9 = MassPoint(initialPosition: const Offset(120, 120));

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
    ElasticEdge(node1: goo1, node2: goo5, length: 42),
    //
    ElasticEdge(node1: goo2, node2: goo3),
    ElasticEdge(node1: goo2, node2: goo4, length: 42),
    ElasticEdge(node1: goo2, node2: goo5),
    ElasticEdge(node1: goo2, node2: goo6, length: 42),
    //
    ElasticEdge(node1: goo3, node2: goo5, length: 42),
    ElasticEdge(node1: goo3, node2: goo6),
    //
    ElasticEdge(node1: goo4, node2: goo5),
    ElasticEdge(node1: goo4, node2: goo7),
    ElasticEdge(node1: goo4, node2: goo8, length: 42),
    //
    ElasticEdge(node1: goo5, node2: goo7, length: 42),
    ElasticEdge(node1: goo5, node2: goo8),
    //
    ElasticEdge(node1: goo7, node2: goo8),
    //
    ElasticEdge(node1: goo5, node2: goo6),
    ElasticEdge(node1: goo5, node2: goo7),
    ElasticEdge(node1: goo5, node2: goo8),
    ElasticEdge(node1: goo5, node2: goo9, length: 42),
    //
    ElasticEdge(node1: goo6, node2: goo8, length: 42),
    ElasticEdge(node1: goo6, node2: goo9),
    //
    ElasticEdge(node1: goo8, node2: goo9),
  ]);

  return (points, springs);
}

(List<MassPoint>, List<ElasticEdge>) createRandomGraph2(
  Size canvasSize, {
  int row = 3,
  int column = 3,
  Offset position = Offset.zero,
  double edgeLength = 30,
}) {
  final List<MassPoint> points = <MassPoint>[];
  final List<ElasticEdge> springs = <ElasticEdge>[];

  Map<(int, int), (int, int)> pointPairs = {};
  final double diagonalLength = sqrt(2 * pow(edgeLength, 2));

  final List<List<MassPoint>> pointsMatrix = List.generate(
    row,
    (i) => List.generate(column, (j) => MassPoint()),
  );

  for (int i = 0; i < row; i++) {
    for (int j = 0; j < column; j++) {
      final List<(int, int)> neighbours =
          getMatrixCellNeighbours(i, j, row, column);

      pointsMatrix[i][j].position =
          Offset(i * edgeLength, j * edgeLength) + position;

      points.add(pointsMatrix[i][j]);

      for (final neighbour in neighbours) {
        if (pointPairs[(i, j)] != neighbour &&
            pointPairs[neighbour] != (i, j)) {
          // Edge doesn't exist.
          pointPairs[(i, j)] = neighbour;
          springs.add(
            ElasticEdge(
              node1: pointsMatrix[i][j],
              node2: pointsMatrix[neighbour.$1][neighbour.$2],
              length: _getPointsDistance(i, j, neighbour) > 1
                  ? diagonalLength
                  : edgeLength,
            ),
          );
        }
      }
    }
  }

  return (points, springs);
}

double _getPointsDistance(int i, int j, (int, int) neighbour) =>
    (Offset(i.toDouble(), j.toDouble()) -
            Offset(neighbour.$1.toDouble(), neighbour.$2.toDouble()))
        .distance;

List<(int, int)> getMatrixCellNeighbours(
  int a,
  int b,
  int rowNumber,
  int columnNumber,
) {
  List<(int, int)> pairs = [];
  for (int i = a - 1; i <= a + 1; i++) {
    for (int j = b - 1; j <= b + 1; j++) {
      if (i < 0 ||
          j < 0 ||
          i > rowNumber - 1 ||
          j > columnNumber - 1 ||
          (i == a && j == b)) {
        continue;
      }

      pairs.add((i, j));
    }
  }
  return pairs;
}
