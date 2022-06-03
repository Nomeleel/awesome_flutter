import 'dart:ui';

import '../widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class TraceRedPathTestView extends StatefulWidget {
  const TraceRedPathTestView({Key? key}) : super(key: key);

  @override
  _TraceRedPathTestViewState createState() => _TraceRedPathTestViewState();
}

class _TraceRedPathTestViewState extends State<TraceRedPathTestView> with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomPaint(
              painter: TraceRedPathPainter(repaint: _controller),
            ),
            ClipPath(
              clipper: TraceRedPathClipper(
                reclip: _controller,
                size: Size(200.0, 150.0),
              ),
              child: _container(),
            ),
            ClipPath(
              clipper: TraceRedPathClipper(
                reclip: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.3,
                    0.9,
                    curve: Curves.bounceIn,
                  ),
                ),
                size: Size(200.0, 150.0),
              ),
              child: _container(),
            ),
            ClipPath(
              clipper: TraceRedPathClipper(
                reclip: CurveTween(
                  curve: Interval(
                    0.3,
                    0.9,
                    curve: Curves.bounceIn,
                  ),
                ).animate(_controller),
                size: Size(200.0, 150.0),
              ),
              child: _container(),
            ),
            ClipPath(
              clipper: TraceRedPathClipper(
                reclip: _controller.drive(
                  CurveTween(
                    curve: Interval(
                      0.3,
                      0.9,
                      curve: Curves.bounceIn,
                    ),
                  ),
                ),
                size: Size(200.0, 150.0),
              ),
              child: _container(),
            ),
            _container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
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

  Container _container() {
    return Container(
      width: 200.0,
      height: 150.0,
      color: Colors.purple,
    );
  }
}

class TraceRedPathPainter extends CustomPainter {
  final AnimationController repaint;
  final PathMetric pathMetric;

  TraceRedPathPainter({required this.repaint})
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

class TraceRedPathClipper extends CustomClipper<Path> {
  final Animation<double> reclip;
  final Size size;
  final PathMetric pathMetric;

  TraceRedPathClipper({required this.reclip, required this.size})
      : pathMetric = (Path()
              ..addRRect(
                RRect.fromRectAndRadius(
                  Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height),
                  Radius.circular(0.0),
                ),
              ))
            .computeMetrics()
            .single,
        super(reclip: reclip);

  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0.0, 0.0, reclip.value * size.width, size.height));
    // return Path()..addPath(pathMetric.extractPath(0, pathMetric.length * reclip.value), Offset.zero);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
