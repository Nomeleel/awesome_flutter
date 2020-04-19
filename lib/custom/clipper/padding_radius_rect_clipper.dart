import 'package:flutter/widgets.dart';

import '../../helper/helper.dart';

class PRRectClipper extends CustomClipper<RRect> {
  
  const PRRectClipper({
    this.padding = EdgeInsets.zero,
    this.radius = BorderRadius.zero,
    this.textDirection = TextDirection.ltr,
  });

  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry radius;
  final TextDirection textDirection;

  @override
  RRect getClip(Size size) {
    EdgeInsets edgeInsets = EdgeInsetsGeometryHelper.getEdgeInsets(padding);
    BorderRadius borderRadius = BorderRadiusGeometryHelper.getBorderRadius(radius);
    
    return RRect.fromLTRBAndCorners(
      edgeInsets.left,
      edgeInsets.top,
      size.width - edgeInsets.right,
      size.height - edgeInsets.bottom,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomRight: borderRadius.bottomRight,
      bottomLeft: borderRadius.bottomLeft,
    );
  }

  @override
  bool shouldReclip(PRRectClipper oldClipper) => oldClipper.padding != padding ||
    oldClipper.radius != radius || oldClipper.textDirection != textDirection;
}
