import 'dart:math';
import 'package:flutter/widgets.dart';

class MagatamaClipper extends CustomClipper<Path> {
  bool isYang;
  MagatamaClipper(this.isYang);

  @override
  Path getClip(Size size) {
    double actualSize = min(size.width, size.height);
    Path path = Path();
    path..addArc(
      Rect.fromCircle(
        center: Offset(actualSize / 2, actualSize / 4), 
        radius: actualSize / 4,
      ),
      pi / 2,
      -pi
    )..addArc(
      Rect.fromCircle(
        center: Offset(actualSize / 2, actualSize * 3 / 4), 
        radius: actualSize / 4,
      ),
      pi / 2,
      pi,
    )..addArc(
      Rect.fromCircle(
        center: Offset(actualSize / 2, actualSize / 2), 
        radius: actualSize / 2,
      ),
      -pi / 2,
      pi * (isYang ? -1 : 1)
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(MagatamaClipper oldClipper) => oldClipper.isYang != isYang;
}