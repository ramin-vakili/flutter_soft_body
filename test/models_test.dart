import 'package:flutter_test/flutter_test.dart';
import 'package:soft_body/models.dart';

void main() {
  group('models test', () {
    group('RectangleCollider should', () {
      final RectangleCollider collider =
          RectangleCollider(points: [], edges: []);

      test('''Its containPoint should 
          return true if point is inside 
          the rectangle ''', () {});
    });
  });
}
