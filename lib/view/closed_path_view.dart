import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ClosedPathTestView extends StatefulWidget {
  const ClosedPathTestView({Key? key}) : super(key: key);

  @override
  State<ClosedPathTestView> createState() => _ClosedPathTestViewState();
}

class _ClosedPathTestViewState extends State<ClosedPathTestView> {
  Color? _color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(border: Border.all()),
          child: SvgMap(
            children: [
              GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                      print(_color);
                    });
                  }
                },
                child: ClosedPathView(
                  Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                  color: _color,
                ),
              ),
              ClosedPathView(
                Path()..addOval(Rect.fromLTWH(0, 0, 50, 100)),
                color: _color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClosedPathView extends SingleChildRenderObjectWidget {
  // TODO: check path closed?
  const ClosedPathView(this.path, {this.color, Widget? child}) : super(child: child);

  final Path path;
  final Color? color;

  @override
  RenderClosedPathView createRenderObject(BuildContext context) {
    return RenderClosedPathView(path, color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderClosedPathView renderObject) {
    renderObject
      ..path = path
      ..color = color;
  }
}

class RenderClosedPathView extends RenderProxyBox {
  RenderClosedPathView(this.path, Color? color) : _color = color;

  Path path;

  Color? get color => _color;
  Color? _color;
  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  // @override
  // void performLayout() {
  //   // layout(constraints, parentUsesSize: false);
  //   size = path.getBounds().size;
  //   // size = Size(constraints.maxWidth, constraints.maxHeight);
  // }

  // @override
  // void performResize() {
  //   size = path.getBounds().size;
  // }

  // @override
  // void layout(Constraints constraints, {bool parentUsesSize = false}) {
  //   print('layout');
  //   super.layout(constraints, parentUsesSize: false);
  // }

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

    context.canvas.drawPath(
      Path()..addRect(path.getBounds()),
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
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

class SvgMap extends MultiChildRenderObjectWidget {
  SvgMap({super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSvgMap();
  }
}

class RenderSvgMap extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SvgMapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SvgMapParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! SvgMapParentData) {
      child.parentData = SvgMapParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    while (child != null) {
      final SvgMapParentData childParentData = child.parentData! as SvgMapParentData;
      // childParentData.offset = Offset(10, 10);
      child.layout(constraints, parentUsesSize: true);

      child = childParentData.nextSibling;
    }
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class SvgMapParentData extends StackParentData {}
