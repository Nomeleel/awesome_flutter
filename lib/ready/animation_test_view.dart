import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimationTestView extends StatefulWidget {
  const AnimationTestView({Key key}) : super(key: key);

  @override
  _AnimationTestViewState createState() => _AnimationTestViewState();
}

class _AnimationTestViewState extends State<AnimationTestView> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Animation Test View',
      body: Stack(
        fit: StackFit.expand,
        children: [
          _timeContainer(0.9, 'T0'),
          ScaleTransition(
            scale: Tween(begin: 1.5, end: 1.0)
                .chain(CurveTween(curve: Interval(0.0, 0.2, curve: Curves.bounceIn)))
                .animate(_controller),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _container('1'),
                  ScaleTransition(
                    scale: Tween(begin: 0.5, end: 1.1)
                        .chain(CurveTween(curve: Interval(0.3, 1.0, curve: Curves.bounceIn)))
                        .animate(_controller),
                    child: _container('2'),
                  ),
                  //_timeTransitionContainer(1.0, 'T1'),
                  ScaleTransition(
                    scale: CurveTween(curve: Threshold(1.0)).animate(_controller),
                    child: _animatedContainer('A2'),
                  ),
                  //_timeContainer(0.3, 'T2'),
                  _animatedContainer('A1'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: FadeTransition(
              opacity: CurveTween(
                curve: Threshold(0.8),
              ).animate(_controller),
              child: ScaleTransition(
                scale: Tween(begin: 1.5, end: 1.0)
                    .chain(CurveTween(
                      curve: Interval(0.8, 1.0, curve: Curves.bounceOut),
                    ))
                    .animate(_controller),
                child: _container('S1', 70.0),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //setState(() {
          _height = 150.0;
          //});
          _controller.reset();
          _controller.forward();
        },
        child: const Text('Go'),
      ),
    );
  }

  Container _container(String tag, [double height = 150.0]) {
    return Container(
      height: height,
      width: height,
      decoration: _boxDecoration,
      alignment: Alignment.center,
      child: Text(
        tag,
        style: TextStyle(fontSize: 50.0),
      ),
    );
  }

  AnimatedContainer _animatedContainer(String tag) {
    print('-------_animatedContainer: $tag ---');
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      height: _height,
      width: _height,
      decoration: _boxDecoration,
      alignment: Alignment.center,
      child: Text(
        tag,
        style: TextStyle(fontSize: 50.0),
      ),
    );
  }

  Widget _gif() {
    // return LinearProgressIndicator();
    return Image.asset(
      'assets/images/YanLu.gif',
      key: UniqueKey(),
      width: 150.0,
      height: 150.0,
      fit: BoxFit.cover,
    );
  }

  Widget _timeTransitionContainer(double time, String tag) {
    print('-------_timeTransitionContainer: $tag ---');
    return ScaleTransition(
      scale: CurveTween(
        curve: Threshold(time),
      ).animate(_controller),
      child: time < _controller.value ? SizedBox.shrink() : _gif(),
    );
  }

  Widget _timeContainer(double time, String tag) {
    print('-------_timeContainer: $tag ---');
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return time > _controller.value ? SizedBox.shrink() : child;
      },
      child: _gif(),
    );
  }

  BoxDecoration get _boxDecoration => BoxDecoration(
        color: Colors.purple,
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      );
}
