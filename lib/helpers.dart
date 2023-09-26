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
