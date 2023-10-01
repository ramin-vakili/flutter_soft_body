import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soft_body/helpers.dart';

void main() {
  group('Get matrix cell neighbours', () {
    test('In the middle', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(1, 1, 3, 3),
          [
            (0, 0),
            (0, 1),
            (0, 2),
            (1, 0),
            (1, 2),
            (2, 0),
            (2, 1),
            (2, 2),
          ],
        ),
        true,
      );
    });

    test('Top left cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(0, 0, 3, 3),
          [
            (0, 1),
            (1, 0),
            (1, 1),
          ],
        ),
        true,
      );
    });

    test('Top middle cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(0, 1, 3, 3),
          [
            (0, 0),
            (0, 2),
            (1, 0),
            (1, 1),
            (1, 2),
          ],
        ),
        true,
      );
    });

    test('Top right cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(0, 2, 3, 3),
          [
            (0, 1),
            (1, 1),
            (1, 2),
          ],
        ),
        true,
      );
    });

    test('left middle cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(1, 0, 3, 3),
          [
            (0, 0),
            (0, 1),
            (1, 1),
            (2, 0),
            (2, 1),
          ],
        ),
        true,
      );
    });

    test('right middle cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(1, 2, 3, 3),
          [
            (0, 1),
            (0, 2),
            (1, 1),
            (2, 1),
            (2, 2),
          ],
        ),
        true,
      );
    });

    test('left bottom cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(2, 0, 3, 3),
          [
            (1, 0),
            (1, 1),
            (2, 1),
          ],
        ),
        true,
      );
    });

    test('bottom middle cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(2, 1, 3, 3),
          [
            (1, 0),
            (1, 1),
            (1, 2),
            (2, 0),
            (2, 2),
          ],
        ),
        true,
      );
    });

    test('bottom right cell', () {
      expect(
        listEquals(
          getMatrixCellNeighbours(2, 2, 3, 3),
          [
            (1, 1),
            (1, 2),
            (2, 1),
          ],
        ),
        true,
      );
    });
  });
}

extension PairsExtension on List<(int, int)> {
  String get printString {
    StringBuffer stringBuffer = StringBuffer();
    for (final pair in this) {
      stringBuffer.write('(${pair.$1}, ${pair.$2}), ');
    }
    return stringBuffer.toString();
  }
}
