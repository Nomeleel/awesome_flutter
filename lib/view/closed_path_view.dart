import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widget/scaffold_view.dart';

class ClosedPathTestView extends StatefulWidget {
  const ClosedPathTestView({Key? key}) : super(key: key);

  @override
  State<ClosedPathTestView> createState() => _ClosedPathTestViewState();
}

final path1 = Path()..addOval(Rect.fromLTWH(0, 0, 100, 100));
final path2 = Path()..addOval(Rect.fromLTWH(0, 0, 120, 120));

class _ClosedPathTestViewState extends State<ClosedPathTestView> {
  Color? _color;

  final offset1 = Offset(0, 0);
  final offset2 = Offset(50, 50);

  final size1 = path1.getBounds().size;
  final size2 = path2.getBounds().size;

  final child1 = Align(
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
  );

  final child2 = Center(
    child: Container(
      width: 50,
      height: 50,
      color: Colors.blue,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Closed Path Test View',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildCase1(context),
          buildCase2(context),
          buildCase3(context),
        ]
            .map(
              (e) => Expanded(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(border: Border.all()),
                  child: e,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildCase1(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: offset1.dx,
          left: offset1.dy,
          width: size1.width,
          height: size1.height,
          child: GestureDetector(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              print('-------ClosedPathView onTap1------------');
              _changeColor();
            },
            child: CustomPaint(
              size: size1,
              painter: ClosedPathPainter(path1, color: _color),
              child: child1,
            ),
          ),
        ),
        Positioned(
          top: offset2.dx,
          left: offset2.dy,
          width: size2.width,
          height: size2.height,
          child: GestureDetector(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              print('-------ClosedPathView onTap2------------');
            },
            child: CustomPaint(
              size: size2,
              painter: ClosedPathPainter(path1, color: _color),
              child: child2,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCase2(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: offset1.dx,
          left: offset1.dy,
          child: GestureDetector(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              print('-------ClosedPathView onTap1------------');
              _changeColor();
            },
            child: ClosedPathView(path1, color: _color, child: child1),
          ),
        ),
        Positioned(
          top: offset2.dx,
          left: offset2.dy,
          child: GestureDetector(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              print('-------ClosedPathView onTap2------------');
            },
            child: ClosedPathView(
              path2,
              color: _color,
              child: child2,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCase3(BuildContext context) {
    return SvgMap(
      children: [
        /*
        MapEntity(
          path: path1,
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              color: _color,
            ),
          ),
        ),
        MapEntity(
          offset: Offset(50, 50),
          path: path2,
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              color: Colors.brown,
            ),
          ),
        ),
        */
        MapEntity(
          offset: offset1,
          path: path1,
          child: GestureDetector(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              print('-------ClosedPathView onTap1------------');
              _changeColor();
            },
            child: ClosedPathView(
              path1,
              color: _color,
              child: child1,
            ),
          ),
        ),
        MapEntity(
          offset: offset2,
          path: path2,
          child: GestureDetector(
            // behavior: HitTestBehavior.opaque,
            onTap: () {
              print('-------ClosedPathView onTap2------------');
            },
            child: ClosedPathView(
              path2,
              color: _color,
              child: child2,
            ),
          ),
        ),
      ],
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

void _paint(Canvas canvas, Path path, Color? color, [Offset offset = Offset.zero]) {
  final paintPath = Path()..addPath(path, offset);

  canvas.drawPath(
    paintPath,
    Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );

  if (color != null) {
    canvas.drawPath(
      paintPath,
      Paint()..color = color,
    );
  }

  canvas.drawPath(
    Path()..addRect(offset & path.getBounds().size),
    Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke,
  );
}

class ClosedPathPainter extends CustomPainter {
  const ClosedPathPainter(this.path, {this.color});
  final Path path;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    _paint(canvas, path, color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO changed
    return false;
  }

  @override
  bool? hitTest(Offset position) {
    print('---------hitTest-------------');
    return path.contains(position);
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
    _paint(context.canvas, path, color, offset);

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
