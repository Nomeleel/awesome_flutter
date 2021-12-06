// Copy 
import 'dart:math' as math;
import 'dart:ui';

import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class MatrixTestView extends StatefulWidget {
  MatrixTestView({Key key}) : super(key: key);

  @override
  _MatrixTestViewState createState() => _MatrixTestViewState();
}

class _MatrixTestViewState extends State<MatrixTestView> with SingleTickerProviderStateMixin {
  Offset _currentDraggingOffset = Offset.zero;
  double _lastOffsetDy = 0.0;
  AnimationController _animationController;

  void _onDragEnd(DragEndDetails details) {
    _lastOffsetDy = _currentDraggingOffset.dy;
    final animation = Tween<double>(begin: _lastOffsetDy, end: 0.0).animate(_animationController);
    animation.addListener(() {
      if (mounted) {
        setState(() {
          _lastOffsetDy = animation.value;
          _currentDraggingOffset = Offset(0.0, _lastOffsetDy);
        });
      }
    });
    if (!_animationController.isAnimating) _animationController.forward(from: 0.0);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _lastOffsetDy += details.primaryDelta;
    if (_lastOffsetDy < -180) {
      _lastOffsetDy = -180.0;
    }
    if (_lastOffsetDy > 180) {
      _lastOffsetDy = 180.0;
    }
    setState(() {
      _currentDraggingOffset = Offset(0.0, _lastOffsetDy);
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotationRequired = false;
    timeDilation = 1.0;
    return Center(
      child: Container(
        height: 200,
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.identity()..rotateZ((math.pi / 180) * lerpDouble(0, -90, 0.0)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final currentAngle = (math.pi / 180) * (_currentDraggingOffset.dy);
              final currentAngleBack = (math.pi / 180) * (_currentDraggingOffset.dy + 180);

              final displayBack = (currentAngle < -1.5 || currentAngle > 1.5);
              return Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    print('onTap');
                  },
                  onVerticalDragEnd: _onDragEnd,
                  onVerticalDragUpdate: _onDragUpdate,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: displayBack ? 0.0 : 1.0,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.002)
                            ..rotateX(currentAngle),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(constraints.maxWidth * 0.05),
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.3, 1.0],
                                colors: [Colors.purple, Colors.grey],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: RotatedBox(
                                quarterTurns: rotationRequired ? -1 : 0,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Credit Card',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        RotatedBox(
                                          quarterTurns: 1,
                                          child: Icon(
                                            Icons.wifi,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Image.asset(
                                              'images/credit_cards/chip_logo.png',
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: TweenAnimationBuilder<int>(
                                              tween: IntTween(begin: 0, end: 10),
                                              duration: const Duration(milliseconds: 800),
                                              builder: (context, snapshot, _) {
                                                return Text(
                                                  '77777777777777777777',
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'CARD HOLDER',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Diegoveloper',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: Text(
                                              'VISA',
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (displayBack)
                        Positioned.fill(
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.002)
                              ..rotateX(currentAngleBack),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(constraints.maxWidth * 0.05),
                                color: Colors.blue,
                              ),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Expanded(
                                    child: Container(
                                      color: Colors.black26,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Spacer(),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'ABC',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ],
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MatrixTestViewState2 extends State<MatrixTestView> {
  ValueNotifier<double> rotate;

  @override
  void initState() {
    super.initState();
    rotate = ValueNotifier(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      body: Center(
        child: GestureDetector(
          onHorizontalDragUpdate: (dragUpdateDetails) {
            print(dragUpdateDetails);
            rotate.value += dragUpdateDetails.delta.dx;
          },
          child: AnimatedBuilder(
            animation: rotate,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(rotate.value),
                child: child,
              );
            },
            child: Container(
              width: 300,
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(-math.pi),
                    child: Container(
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        'B',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.amber,
                    alignment: Alignment.center,
                    child: Text(
                      'A',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
