import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

class RollingTransition extends AnimatedWidget{

  /// Creates a rolling transition.
  ///
  /// The [controller] argument must not be null.
  const RollingTransition({
    Key? key,
    required this.controller,
    this.rollingVector,
    this.rollingTurns = 1.0,
    this.alignment = Alignment.center,
    required this.child,
  }) : super(key: key, listenable: controller);

  /// The animation that controls the rolling of the child.
  final AnimationController controller;

  /// The animation that rolling vector of the child.
  final Vector3? rollingVector;

  /// The animation that the rolling turns of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  final double rollingTurns;

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
    final double rollingValue = controller.value;
    final Matrix4 transform = Matrix4.zero()..setFromTranslationRotation(
      (rollingVector ?? Vector3.zero()) * rollingValue, 
      Quaternion.fromRotation(Matrix3.rotationZ(
        rollingValue * math.pi * 2.0 * rollingTurns)),
    );
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }

}