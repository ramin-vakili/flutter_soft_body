import 'dart:math';
import 'dart:ui';

import 'models.dart';

/// Generates some random edges between random node pairs in [nodes] list.
List<EdgeBase> generateRandomEdgesForNodes(List<MassPoint> nodes) {
  final List<EdgeBase> edges = <EdgeBase>[];

  for (int i = 0; i < 20; i++) {
    final (int, int) randomPairs = getRandomEdgePairs(nodes);

    edges.add(Spring(
      point1: nodes[randomPairs.$1],
      point2: nodes[randomPairs.$2],
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
  // Collider 1
  Offset collier1TopLeft = Offset(0, size.height / 4);
  Offset collier1TopRight = Offset(size.width / 2.6, size.height / 3 + 25);
  Offset collier1BottomLeft = Offset(0, size.height / 3 + 30);
  Offset collier1BottomRight = Offset(size.width / 2.7, size.height / 2.5 + 30);

  final List<Offset> points1 = <Offset>[
    collier1TopLeft,
    collier1TopRight,
    collier1BottomLeft,
    collier1BottomRight
  ];

  final List<ColliderEdge> edges1 = <ColliderEdge>[
    ColliderEdge(collier1TopLeft, collier1TopRight),
    ColliderEdge(collier1TopRight, collier1BottomRight),
    ColliderEdge(collier1BottomRight, collier1BottomLeft),
    ColliderEdge(collier1BottomLeft, collier1TopLeft),
  ];

  final collider1 = RectangleCollider(points: points1, edges: edges1);

  // Collider 2
  Offset collier2TopLeft =
      Offset(size.width - size.width / 2.2, size.height / 1.8);
  Offset collier2TopRight = Offset(size.width, size.height / 2.5);
  Offset collier2BottomLeft =
      Offset(size.width - size.width / 2.2, size.height / 1.5 + 10);
  Offset collier2BottomRight = Offset(size.width, size.height / 2.5 + 60);

  final List<Offset> points2 = <Offset>[
    collier2TopLeft,
    collier2TopRight,
    collier2BottomLeft,
    collier2BottomRight
  ];

  final List<ColliderEdge> edges2 = <ColliderEdge>[
    ColliderEdge(collier2TopLeft, collier2TopRight),
    ColliderEdge(collier2TopRight, collier2BottomRight),
    ColliderEdge(collier2BottomRight, collier2BottomLeft),
    ColliderEdge(collier2BottomLeft, collier2TopLeft),
  ];

  final collider2 = RectangleCollider(points: points2, edges: edges2);

  // Ground
  final Offset groundTopLeft = Offset(0, size.height - 10);
  final Offset groundTopRight = Offset(size.width, size.height - 10);
  final Offset groundBottomRight = Offset(size.width, size.height);
  final Offset groundBottomLeft = Offset(0, size.height);

  final RectangleCollider ground = RectangleCollider(
    points: [
      groundTopLeft,
      groundTopRight,
      groundBottomRight,
      groundBottomLeft
    ],
    edges: [
      ColliderEdge(groundTopLeft, groundTopRight),
      ColliderEdge(groundTopRight, groundBottomRight),
      ColliderEdge(groundBottomRight, groundBottomLeft),
      ColliderEdge(groundBottomLeft, groundTopLeft),
    ],
  );

  return [
    collider1,
    collider2,
    ground,
  ];
}

(List<MassPoint>, List<Spring>) createRandomGraph(Size canvasSize) {
  final List<MassPoint> points = <MassPoint>[];
  final List<Spring> springs = <Spring>[];

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
    Spring(point1: goo1, point2: goo2),
    Spring(point1: goo1, point2: goo4),
    Spring(point1: goo1, point2: goo5, restLength: 42),
    //
    Spring(point1: goo2, point2: goo3),
    Spring(point1: goo2, point2: goo4, restLength: 42),
    Spring(point1: goo2, point2: goo5),
    Spring(point1: goo2, point2: goo6, restLength: 42),
    //
    Spring(point1: goo3, point2: goo5, restLength: 42),
    Spring(point1: goo3, point2: goo6),
    //
    Spring(point1: goo4, point2: goo5),
    Spring(point1: goo4, point2: goo7),
    Spring(point1: goo4, point2: goo8, restLength: 42),
    //
    Spring(point1: goo5, point2: goo7, restLength: 42),
    Spring(point1: goo5, point2: goo8),
    //
    Spring(point1: goo7, point2: goo8),
    //
    Spring(point1: goo5, point2: goo6),
    Spring(point1: goo5, point2: goo7),
    Spring(point1: goo5, point2: goo8),
    Spring(point1: goo5, point2: goo9, restLength: 42),
    //
    Spring(point1: goo6, point2: goo8, restLength: 42),
    Spring(point1: goo6, point2: goo9),
    //
    Spring(point1: goo8, point2: goo9),
  ]);

  return (points, springs);
}

SoftBody generateSampleSoftBody(
  Size canvasSize, {
  int row = 3,
  int column = 3,
  Offset position = Offset.zero,
  double edgeLength = 30,
}) {
  final List<MassPoint> points = <MassPoint>[];
  final List<Spring> springs = <Spring>[];

  Map<(int, int), (int, int)> pointPairs = {};
  final double diagonalLength = sqrt(2 * pow(edgeLength, 2));

  final List<List<MassPoint>> pointsMatrix = List.generate(
    row,
    (i) => List.generate(column, (j) => MassPoint()),
  );

  final List<MassPoint> paintingPathPoints =
      getSoftBodyPaintingPoints(pointsMatrix);

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
            Spring(
              point1: pointsMatrix[i][j],
              point2: pointsMatrix[neighbour.$1][neighbour.$2],
              restLength: _getPointsDistance(i, j, neighbour) > 1
                  ? diagonalLength
                  : edgeLength,
            ),
          );
        }
      }
    }
  }

  return SoftBody(points, springs, paintingPathPoints);
}

List<MassPoint> getSoftBodyPaintingPoints(List<List<MassPoint>> pointsMatrix) {
  final List<MassPoint> pathPoints = <MassPoint>[];

  // Top row
  for (int j = 0; j < pointsMatrix.first.length; j++) {
    pathPoints.add(pointsMatrix[0][j]);
  }

  // right side
  for (int i = 1; i < pointsMatrix.length; i++) {
    pathPoints.add(pointsMatrix[i][pointsMatrix.first.length - 1]);
  }

  // bottom side
  for (int j = pointsMatrix.first.length - 1; j >= 0; j--) {
    pathPoints.add(pointsMatrix[pointsMatrix.length - 1][j]);
  }

  // left side
  for (int i = pointsMatrix.length - 1; i > 0; i--) {
    pathPoints.add(pointsMatrix[i][0]);
  }

  return pathPoints;
}

double _getPointsDistance(int i, int j, (int, int) neighbour) =>
    (Offset(i.toDouble(), j.toDouble()) -
            Offset(neighbour.$1.toDouble(), neighbour.$2.toDouble()))
        .distance;

/// Returns the neighbours in ([a], [b]) position in a 2D matrix with number of
/// [rowNumber] rows and [columnNumber] columns.
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
