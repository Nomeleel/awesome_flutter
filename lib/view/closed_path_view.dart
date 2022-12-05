import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ClosedPathTestView extends StatefulWidget {
  const ClosedPathTestView({Key? key}) : super(key: key);

  @override
  State<ClosedPathTestView> createState() => _ClosedPathTestViewState();
}

class _ClosedPathTestViewState extends State<ClosedPathTestView> {
  Color? _color = Colors.amber;
  @override
  Widget build(BuildContext context) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, 100, 100));
    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(border: Border.all()),
          child: GestureDetector(
            onTap: () {
              print('--');
              if (mounted) {
                setState(() {
                  _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                });
              }
            },
            child: ClosedPathView(
              path,
              color: _color,
            ),
          ),
        ),
      ),
    );
  }
}

class ClosedPathView extends SingleChildRenderObjectWidget {
  // TODO: check path closed?
  const ClosedPathView(this.path, {this.color, super.child});

  final Path path;
  final Color? color;

  @override
  RenderClosedPathView createRenderObject(BuildContext context) {
    return RenderClosedPathView(path, color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderClosedPathView renderObject) {
    print(color);
    renderObject
      ..path = path
      ..color = color;
  }
}

class RenderClosedPathView extends RenderProxyBox {
  RenderClosedPathView(this.path, this.color);

  Path path;
  Color? color;

  @override
  void performLayout() {
    // size = path.getBounds().size;
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.translate(offset.dx, offset.dy);
    context.canvas.drawPath(
      path,
      Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.stroke,
    );
    if (color != null) {
      context.canvas.drawPath(
        path,
        Paint()..color = color!,
      );
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (path.contains(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}
