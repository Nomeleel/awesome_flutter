import 'dart:ui';

import '../widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TraceRedPathTestView extends StatefulWidget {
  const TraceRedPathTestView({Key key}) : super(key: key);

  @override
  _TraceRedPathTestViewState createState() => _TraceRedPathTestViewState();
}

class _TraceRedPathTestViewState extends State<TraceRedPathTestView> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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
      title: 'Trace Red Path Test View',
      body: Center(
        child: CustomPaint(
          painter: TraceRedPathPainter(repaint: _controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
        child: const Text('Go'),
      ),
    );
  }
}

class TraceRedPathPainter extends CustomPainter {
  final AnimationController repaint;
  final PathMetric pathMetric;

  TraceRedPathPainter({this.repaint})
      : pathMetric = (Path()
              ..addRRect(
                RRect.fromRectAndRadius(
                  Rect.fromCenter(center: Offset.zero, width: 200.0, height: 150.0),
                  Radius.circular(20.0),
                ),
              ))
            .computeMetrics()
            .single,
        super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.addPath(pathMetric.extractPath(0, pathMetric.length * repaint.value), Offset.zero);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
