import 'dart:math';

import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FollowView extends StatelessWidget {
  const FollowView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
      initialPage: 2,
      viewportFraction: 0.8,
    );
    controller.addListener(() {});
    return ScaffoldView(
      title: 'Follow View',
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints.expand(height: 200.0),
            child: CustomPaint(
              painter: ArcIndicatorPainter(repaint: controller, level: 3),
            ),
          ),
          /*
          Container(
            height: 200.0,
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  // 0 < controller.page < pageSize 但是两端溢出值我还是要的
                  angle: controller.hasClients ? -controller.offset / 500 : controller.initialPage.toDouble(),
                  child: child,
                );
              },
              child: Container(
                height: 77.0,
                width: 77.0,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  '|',
                  style: TextStyle(fontSize: 77.0),
                ),
              ),
            ),
          ),
          */
          SizedBox(
            height: 220.0,
            child: PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ArcIndicatorPainter extends CustomPainter {
  const ArcIndicatorPainter({
    this.repaint,
    this.level = 1,
    this.maxLevel = 7,
  }) : super(repaint: repaint);

  final PageController repaint;
  final int level;
  final int maxLevel;

  // 0 ~ pi / 2
  final offsetAngle = pi * .25;

  double get startAngle => pi / 2 - offsetAngle;
  double get sweepAngle => -pi + offsetAngle * 2;
  Tween<double> get tween => Tween(begin: 0, end: sweepAngle);
  // 0.0 <= repaint.page <= pageSize - 1 但是两端溢出值我还是要的
  double get curPage {
    double overflow = 0;
    if (repaint.offset < 0) overflow = repaint.offset;
    if (repaint.offset > repaint.position.maxScrollExtent) overflow = repaint.offset - repaint.position.maxScrollExtent;
    return repaint.page + overflow / 500.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // bg color
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.grey.withOpacity(.7),
    );

    final center = Offset(size.width / 2, -size.width);
    canvas.translate(center.dx, center.dy);

    // bg arc color
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: size.width + size.height),
      startAngle,
      pi * 2,
      false,
      Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeWidth = size.height * 1.3,
    );

    canvas.rotate(offsetAngle - _sweepAngle(curPage));

    final radius = size.width + size.height * 0.8;

    // arc line
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeWidth = 3,
    );

    // arc active line
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle,
      _sweepAngle(level - 1),
      false,
      Paint()
        ..color = Colors.yellowAccent
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeWidth = 5,
    );

    // indicator point
    final angle = startAngle + _sweepAngle(repaint.page.floor());
    canvas.drawCircle(
      Offset(cos(angle) * radius, sin(angle) * radius),
      9.0,
      Paint()..color = Colors.yellow.withOpacity(.7),
    );

    // arc line point / active
    for (int i = 0; i < maxLevel; i++) {
      final angle = startAngle + _sweepAngle(i);
      canvas.drawCircle(
        Offset(cos(angle) * radius, sin(angle) * radius),
        6.0,
        Paint()..color = i < level ? Colors.yellow : Colors.black,
      );
    }

    canvas.rotate(-offsetAngle);

    // arc line point text
    for (int i = 0; i < maxLevel; i++) {
      final TextPainter painter = TextPainter(
        text: TextSpan(
          style: TextStyle(
            color: Colors.purple,
            fontSize: 14,
          ),
          children: [
            TextSpan(text: 'V', style: TextStyle(fontSize: 12)),
            TextSpan(text: '${i + 1}'),
          ],
        ),
        textDirection: TextDirection.ltr,
      );
      painter.layout();

      // active text bg
      if (i == level - 1) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(0, radius + 18.5), width: painter.width + 10.0, height: painter.height),
            Radius.circular(20.0),
          ),
          Paint()..color = Colors.amber,
        );
      }

      painter.paint(
        canvas,
        Offset(
          -painter.width / 2,
          radius + 10.0,
        ),
      );
      canvas.rotate(_sweepAngle(1));
    }
  }

  double _sweepAngle(num index) => tween.transform(index / (maxLevel - 1));

  @override
  bool shouldRepaint(covariant ArcIndicatorPainter oldDelegate) => false;
}
