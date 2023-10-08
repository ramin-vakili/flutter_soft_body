import 'package:flutter/material.dart';

import 'models.dart';

extension OffsetExtension on Offset {
  double get x => dx;

  double get y => dy;

  Offset get normalized => this / distance;
}

extension MassPointListExtension on List<MassPoint> {
  String get positionsPrintString {
    StringBuffer stringBuffer = StringBuffer();

    for (final point in this) {
      stringBuffer.write(
          '(${point.position.dx.toStringAsFixed(0)}, ${point.position.dy.toStringAsFixed(0)}), ');
    }

    return stringBuffer.toString();
  }

  String get forcePrintString {
    StringBuffer stringBuffer = StringBuffer();

    for (final point in this) {
      stringBuffer.write(
          '(${point.force.dx.toStringAsFixed(0)}, ${point.force.dy.toStringAsFixed(0)}), ');
    }

    return stringBuffer.toString();
  }
}
