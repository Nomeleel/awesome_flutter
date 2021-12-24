import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class PrizeWheelView extends StatefulWidget {
  const PrizeWheelView({Key? key}) : super(key: key);

  @override
  _PrizeWheelViewState createState() => _PrizeWheelViewState();
}

class _PrizeWheelViewState extends State<PrizeWheelView> with TickerProviderStateMixin {
  double paintWidth = .0;
  Offset centerPoint = Offset.zero;
  double speed = .0;

  final ValueNotifier<double> turnsValue = ValueNotifier<double>(.0);
  late AnimationController controller = AnimationController(vsync: this)
    ..addListener(() => turnsValue.value += controller.value);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      paintWidth = MediaQuery.of(context).size.width - 10.0;
      centerPoint = Offset(paintWidth / 2, paintWidth / 2);
      setState(() {});
    });
  }

  Offset point = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prize Wheel View'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.cyan,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 5.0,
                right: 5.0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Listener(
                  onPointerDown: (PointerDownEvent event) {
                    speed = .0;
                  },
                  onPointerMove: (PointerMoveEvent event) {
                    final Offset endPoint = event.localPosition;
                    final Offset startPoint = endPoint - event.delta;
                    print('---------${event.localPosition}-----------');
                    print('---------${endPoint - point}-----------');
                    print('---------${event.delta}-----------');
                    point = endPoint;
                    final double acos = math.acos(cosA(startPoint - centerPoint, endPoint - centerPoint, event.delta));
                    //final double direction;
                    //if (acos > speed) {
                    speed = acos;
                    //}
                    print(acos);
                    turnsValue.value += acos;
                    //turnsValue.value += math.atan2(event.localPosition.dy, event.localPosition.dx);
                  },
                  onPointerUp: (PointerUpEvent event) {
                    //onFlying(speed);
                  },
                  child: AnimatedBuilder(
                    animation: turnsValue,
                    builder: (BuildContext context, Widget? child) {
                      // RotatedBox ?
                      final Matrix4 transform = Matrix4.rotationZ(turnsValue.value);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: Size.square(paintWidth),
                      painter: BodyMassIndexPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.deepOrange,
            ),
          )
        ],
      ),
    );
  }

  void onFlying(double speed) {
    const SpringDescription spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final Simulation simulation = SpringSimulation(spring, 0, 1, -speed);

    controller.animateWith(simulation);
  }
}

double cosA(
  Offset ab,
  Offset ac,
  Offset bc,
) {
  return (ab.distanceSquared + ac.distanceSquared - bc.distanceSquared) / (2 * ab.distance * ac.distance);
}

class BodyMassIndexPainter extends CustomPainter {
  double _painterRadius = 0;

  // style
  // 依据转盘结果适当改变颜色
  final Color _textColor = Colors.white;
  final Color _backgroundColor = Colors.blue.withOpacity(0.5);
  final Color _backgroundHighlightColor = Colors.blue;
  final Color _borderColor = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    _painterRadius = size.width / 2;

    canvas.translate(_painterRadius, _painterRadius);
    canvas.save();
    _drawBackground(canvas);

    final double weightRadius = size.width / 2 * 0.9;

    canvas.rotate(-pi * 0.75);

    for (int i = 0; i <= 90; i++) {
      final double width = weightRadius / 195 + (i % 5 == 0 ? 2.0 : 0.0);
      final double height = weightRadius / 27 + (i % 5 == 0 ? 5.0 : 0.0);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(0, -weightRadius * 0.7 - (height / 2)),
          width: width,
          height: height,
        ),
        Paint()..color = _textColor,
      );

      if (i % 10 == 0) {
        final TextPainter painter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: TextStyle(
              color: _textColor,
              fontSize: weightRadius / 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        painter.layout();
        painter.paint(
          canvas,
          Offset(
            -painter.width / 2,
            -weightRadius + weightRadius / 18,
          ),
        );
      }

      canvas.rotate(pi * 2 / 120);
    }

    canvas.rotate(-pi * 2 / 120);

    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: _painterRadius * 0.6),
        -pi * 0.125 * i,
        -pi * 0.125,
        true,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.primaries[i],
      );
    }
    canvas.restore();

    _drawHeightPanel(canvas);
  }

  void _drawHeightPanel(Canvas canvas) {
    canvas.rotate(pi * 2 / 2.655);

    _drawHeightBackground(canvas);

    final double heightRadius = _painterRadius * 0.6;

    canvas.rotate(pi * 0.75);

    for (int i = 0; i <= 60; i++) {
      final double height = heightRadius / 27 + (i % 5 == 0 ? 5.0 : 0.0);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(0, -heightRadius + (height / 2)),
          width: heightRadius / 195 + (i % 5 == 0 ? 2.0 : 0.0),
          height: height,
        ),
        Paint()..color = _textColor,
      );

      if (i % 10 == 0) {
        final TextPainter painter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: TextStyle(
              color: _textColor,
              fontSize: heightRadius / 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        painter.layout();
        painter.paint(
          canvas,
          Offset(
            -painter.width / 2,
            -heightRadius + heightRadius / 7,
          ),
        );
      }

      canvas.rotate(pi * 2 / 120);
    }
  }

  void _drawHeightBackground(Canvas canvas) {
    final double heightPanelRadius = _painterRadius * 0.6;
    final Rect fullCircleRect = Rect.fromCircle(center: Offset.zero, radius: heightPanelRadius);
    final ui.Gradient gradient = ui.Gradient.radial(
      fullCircleRect.center,
      heightPanelRadius,
      <Color>[Colors.green[700]!, Colors.green],
      const <double>[0, .7],
    );

    final Path sectorPath = Path.combine(
      PathOperation.difference,
      Path()
        ..addArc(Rect.fromCircle(center: Offset.zero, radius: heightPanelRadius * 0.8), 0, -pi * 0.5)
        ..lineTo(0, 0),
      Path()
        ..addArc(Rect.fromCircle(center: Offset.zero, radius: heightPanelRadius * 0.6), 0, -pi * 0.5)
        ..lineTo(0, 0),
    );

    final Path heightPath = Path.combine(PathOperation.difference, Path()..addOval(fullCircleRect), sectorPath);

    canvas.drawPath(
      heightPath,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient,
    );
  }

  void _drawBackground(Canvas canvas) {
    final Rect fullCircleRect = Rect.fromCircle(center: Offset.zero, radius: _painterRadius);
    final ui.Gradient gradient = ui.Gradient.radial(
      fullCircleRect.center,
      _painterRadius,
      <Color>[_backgroundHighlightColor, _backgroundColor],
      const <double>[0, .7],
    );

    canvas.drawOval(
        fullCircleRect,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = gradient);

    canvas.drawOval(
        fullCircleRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = _borderColor
          ..strokeWidth = 0.3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
