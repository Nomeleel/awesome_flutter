import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector64;

class YinYangSwitchView extends StatefulWidget {
  @override
  YinYangSwitchViewState createState() => YinYangSwitchViewState();
}

class YinYangSwitchViewState extends State<YinYangSwitchView> with TickerProviderStateMixin {
  // TODO size关联设置
  AnimationController controller;
  Color color;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    Animation<Color> animation = ColorTween(begin: Colors.white, end: Colors.black).animate(controller);
    controller.addListener((){
      setState(() => color = animation.value);
    });
    color = Colors.white;

    super.initState();
  }

  // TODO 解决初始居中的问题 
  @override
  Widget build(BuildContext context){
    return Container(
      color: color,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else if (controller.status == AnimationStatus.dismissed) {
              controller.forward();
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    width: 5,
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: RotationTransition2(
                  alignment: Alignment.center,
                  turns: controller,
                  child: Container(
                    alignment: Alignment.center,
                    width: 90,
                    height: 90,
                    color: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          child: Container(
                            color: Colors.white,
                          ),
                          clipper: MagatamaClipper(true),
                        ),
                        Positioned(
                          left: 37.5,
                          top: 15,
                          child: ClipOval(
                            child: Container(
                              width: 15,
                              height: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ClipPath(
                          child: Container(
                            color: Colors.black,
                          ),
                          clipper: MagatamaClipper(false),
                        ),
                        Positioned(
                          left: 37.5,
                          top: 60,
                          child: ClipOval(
                            child: Container(
                              width: 15,
                              height: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


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
  bool shouldReclip(MagatamaClipper oldClipper) => true;
}

class RotationTransition2 extends AnimatedWidget {
  // TODO 改名字 => 滚动动画
  // TODO 目标点偏移量参数 旋转角度
  /// Creates a rotation transition.
  ///
  /// The [turns] argument must not be null.
  const RotationTransition2({
    Key key,
    @required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  }) : assert(turns != null),
       super(key: key, listenable: turns);

  // TODO 重命名
  /// The animation that controls the rotation of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Animation<double> get turns => listenable;

  /// The alignment of the origin of the coordinate system around which the
  /// rotation occurs, relative to the size of the box.
  ///
  /// For example, to set the origin of the rotation to top right corner, use
  /// an alignment of (1.0, -1.0) or use [Alignment.topRight]
  final Alignment alignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.zero()..setFromTranslationRotation(
      vector64.Vector3(100 * turnsValue, 0, 0), 
      vector64.Quaternion.fromRotation(vector64.Matrix3.rotationZ(turnsValue * pi)),
    );
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}