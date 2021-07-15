import 'dart:math';

import 'package:flutter/material.dart';

class LevelFollow extends StatelessWidget {
  const LevelFollow.builder({
    Key key,
    this.level = 1,
    this.itemCount,
    this.levelPanelHeight = 220.0,
    this.itemHeight = 200.0,
    @required this.itemBuilder,
    this.viewportFraction = 0.8,
  }) : super(key: key);

  final int level;
  final double levelPanelHeight;
  final int itemCount;
  final double itemHeight;
  final IndexedWidgetBuilder itemBuilder;
  final double viewportFraction;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      initialPage: level - 1,
      viewportFraction: viewportFraction,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints.expand(height: levelPanelHeight),
          child: CustomPaint(
            painter: ArcIndicatorPainter(
              repaint: controller,
              level: level,
              maxLevel: itemCount,
            ),
          ),
        ),
        SizedBox(
          height: itemHeight,
          child: PageView.builder(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ),
      ],
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

    // arc mock line
    for (int i = 1; i < 6; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: size.width + size.height * (i * 0.225 + 0.35)),
        startAngle,
        2 * pi,
        false,
        Paint()
          ..color = Colors.black.withOpacity(.2)
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true
          ..strokeWidth = 2.5,
      );
    }

    final radius = size.width + size.height * 0.8;

    // arc line
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle,
      sweepAngle - pi / 2,
      false,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeWidth = 2.5,
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
        ..strokeWidth = 3,
    );

    // arc forward line
    if (repaint.page > level - 1) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle + _sweepAngle(level - 1),
        _sweepAngle(repaint.page - level + 1),
        false,
        Paint()
          ..color = Colors.yellowAccent.shade700
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true
          ..strokeWidth = 3,
      );
    }

    // indicator point
    if (repaint.page.floor() == repaint.page) {
      final angle = startAngle + _sweepAngle(repaint.page);
      canvas.drawCircle(
        Offset(cos(angle) * radius, sin(angle) * radius),
        7.0,
        Paint()..color = Colors.yellow.withOpacity(.7),
      );
    }

    // arc line point / active
    for (int i = 0; i < maxLevel; i++) {
      final angle = startAngle + _sweepAngle(i);
      canvas.drawCircle(
        Offset(cos(angle) * radius, sin(angle) * radius),
        5.0,
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
            Rect.fromCenter(center: Offset(0, radius + 20.0), width: painter.width + 10.0, height: painter.height),
            Radius.circular(20.0),
          ),
          Paint()..color = Colors.amber,
        );
      }

      painter.paint(
        canvas,
        Offset(
          -painter.width / 2,
          radius + 12.0,
        ),
      );
      canvas.rotate(_sweepAngle(1));
    }
  }

  double _sweepAngle(num index) => tween.transform(index / (maxLevel - 1));

  @override
  bool shouldRepaint(covariant ArcIndicatorPainter oldDelegate) => false;
}
