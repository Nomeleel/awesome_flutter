import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class WaveRectClipper extends CustomClipper<Path> {
  final double animationValue;
  final Offset offset;

  WaveRectClipper(this.animationValue, this.offset);

  @override
  Path getClip(Size size) {
    Path path = Path();

    // ware path
    // TODO 没水时 底部还有波浪
    for (double i = - offset.dx; i <= size.width; i++) {
      path.lineTo(
          i +  offset.dx,
          3 * sin((animationValue * 360 - i) * vector.degrees2Radians) + offset.dy);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveRectClipper oldClipper) =>
      this.animationValue != oldClipper.animationValue;
}
