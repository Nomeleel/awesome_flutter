import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vector64;

class RollingTransition extends AnimatedWidget{

  /// Creates a rolling transition.
  ///
  /// The [turns] argument must not be null.
  const RollingTransition({
    Key key,
    @required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  }) : assert(turns != null),
       super(key: key, listenable: turns);

  /// The animation that controls the rolling of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Animation<double> get turns => listenable;

  /// The alignment of the origin of the coordinate system around which the
  /// rolling occurs, relative to the size of the box.
  ///
  /// For example, to set the origin of the rolling to top right corner, use
  /// an alignment of (1.0, -1.0) or use [Alignment.topRight]
  final Alignment alignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final double diameter = MediaQuery.of(context).size.shortestSide;
    final Matrix4 transform = Matrix4.zero()..setFromTranslationRotation(
      vector64.Vector3(turnsValue * math.pi * diameter, 0, 0), 
      vector64.Quaternion.fromRotation(vector64.Matrix3.rotationZ(turnsValue * math.pi * 2.0)),
    );
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }

}