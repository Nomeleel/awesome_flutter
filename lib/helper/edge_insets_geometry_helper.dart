import 'package:flutter/widgets.dart';

class EdgeInsetsGeometryHelper {

  static EdgeInsets getEdgeInsets(EdgeInsetsGeometry edgeInsetsGeometry, {TextDirection textDirection = TextDirection.ltr}) {
    return edgeInsetsGeometry == null ? EdgeInsets.zero : edgeInsetsGeometry.resolve(textDirection);
  }

}
