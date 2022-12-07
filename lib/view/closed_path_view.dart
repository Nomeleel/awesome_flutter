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
          child: GestureDetector(
            onTap: () {
              print('-------onTap------------');
              _changeColor();
            },
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  // width: 100,
                  // height: 100,
                  child: GestureDetector(
                    // behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('-------ClosedPathView onTap1------------');
                      _changeColor();
                    },
                    child: ClosedPathView(
                      Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                      color: _color,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            print('-------ClosedPathView child onTap1------------');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  width: 100,
                  height: 100,
                  child: GestureDetector(
                    // behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('-------ClosedPathView onTap2------------');
                    },
                    child: ClosedPathView(
                      Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                      color: _color,
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(border: Border.all()),
          child: GestureDetector(
            onTap: () {
              print('-------onTap------------');
              _changeColor();
            },
            child: SvgMap(
              children: [
                // MapEntity(
                //   path: Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                //   child: Center(
                //     child: Container(
                //       width: 50,
                //       height: 50,
                //       color: _color,
                //     ),
                //   ),
                // ),
                // MapEntity(
                //   offset: Offset(50, 50),
                //   path: Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                //   child: Center(
                //     child: Container(
                //       width: 50,
                //       height: 50,
                //       color: Colors.brown,
                //     ),
                //   ),
                // ),
                MapEntity(
                  path: Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                  child: GestureDetector(
                    // behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('-------ClosedPathView onTap1------------');
                      _changeColor();
                    },
                    child: ClosedPathView(
                      Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                      color: _color,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            print('-------ClosedPathView child onTap1------------');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                MapEntity(
                  offset: Offset(50, 50),
                  path: Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                  child: GestureDetector(
                    // behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('-------ClosedPathView onTap2------------');
                    },
                    child: ClosedPathView(
                      Path()..addOval(Rect.fromLTWH(0, 0, 100, 100)),
                      color: _color,
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeColor() {
    if (mounted) {
      setState(() {
        _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        print(_color);
      });
    }
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
    renderObject
      ..path = path
      ..color = color;
  }
}

class RenderClosedPathView extends RenderProxyBox {
  RenderClosedPathView(Path path, Color? color)
      : _path = path,
        _color = color;

  Path get path => _path;
  Path _path;
  set path(Path value) {
    if (_path != value) {
      _path = value;
      markNeedsLayout();
    }
  }

  Color? get color => _color;
  Color? _color;
  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = path.getBounds().size;
    child?.layout(BoxConstraints.loose(size));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paintPath = Path()..addPath(path, offset);

    context.canvas.drawPath(
      paintPath,
      Paint()
        ..color = Colors.purple
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    if (color != null) {
      context.canvas.drawPath(
        paintPath,
        Paint()..color = color!,
      );
    }

    context.canvas.drawPath(
      Path()..addRect(offset & path.getBounds().size),
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    if (child != null) context.paintChild(child!, offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    print('-------------close path ${path.hashCode} hit test: $position------------------');
    if (hitTestSelf(position)) {
      hitTestChildren(result, position: position);
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  @override
  bool hitTestSelf(Offset position) => path.contains(position);
}

class SvgMap extends MultiChildRenderObjectWidget {
  SvgMap({required List<Widget> children}) : super(children: children);

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
    print('performLayout: $constraints');
    RenderBox? child = firstChild;
    size = Size(constraints.maxWidth, constraints.maxHeight);
    while (child != null) {
      final SvgMapParentData childParentData = child.parentData! as SvgMapParentData;

      child.layout(BoxConstraints.loose(childParentData.path?.getBounds().size ?? size));
      child = childParentData.nextSibling;
    }
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

class SvgMapParentData extends ContainerBoxParentData<RenderBox> {
  Path? path;
}

class MapEntity extends ParentDataWidget<SvgMapParentData> {
  MapEntity({
    Key? key,
    this.offset = Offset.zero,
    required this.path,
    Widget? child,
  }) : super(key: key, child: child ?? SizedBox.shrink());

  final Offset offset;
  final Path path;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData! as SvgMapParentData;
    parentData.offset = offset;
    parentData.path = path;
  }

  @override
  Type get debugTypicalAncestorWidgetClass => SvgMap;
}
