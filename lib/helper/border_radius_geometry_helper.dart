import 'package:flutter/widgets.dart';

class BorderRadiusGeometryHelper {

  static BorderRadius getBorderRadius(BorderRadiusGeometry borderRadiusGeometry, {TextDirection textDirection = TextDirection.ltr}) {
    return borderRadiusGeometry == null ? BorderRadius.zero : borderRadiusGeometry.resolve(textDirection);
  }

}
