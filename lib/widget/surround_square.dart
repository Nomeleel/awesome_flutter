import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SurroundSquare extends MultiChildRenderObjectWidget {
  SurroundSquare({
    Key? key,
    this.childAspectRatio = 2.0,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  final double childAspectRatio;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSurroundSquare(childAspectRatio: childAspectRatio);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSurroundSquare renderObject) {
    renderObject..childAspectRatio = childAspectRatio;
  }
}

// a. 可以重写performLayout自定义布局(hitTest需要同步)
// b. 嵌套Positioned 然后使用RenderStack默认布局
class RenderSurroundSquare extends RenderStack {
  RenderSurroundSquare({double childAspectRatio = 2.0})
      : _childAspectRatio = childAspectRatio,
        super(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.loose,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.none,
        );

  double _childAspectRatio;
  double get childAspectRatio => _childAspectRatio;
  set childAspectRatio(double value) {
    if (_childAspectRatio != value) {
      _childAspectRatio = value;
      markNeedsLayout();
    }
  }

  double offset = .0;

  @override
  void performLayout() {
    //super.constraints.constrain(size);

    _positionedLayout();

    super.performLayout();
  }

  void _positionedLayout() {
    final double squareLength = constraints.maxWidth - offset * 2.0;
    final double unit = squareLength / (childAspectRatio + 1.0).toDouble();
    final double allOffset = unit + offset;

    RenderBox? child = firstChild;
    int index = 0;

    while (child != null) {
      final StackParentData childParentData = child.parentData as StackParentData;

      switch (index) {
        case 0:
          childParentData
            ..left = offset
            ..right = allOffset
            ..top = offset
            ..height = unit;
          break;
        case 1:
          childParentData
            ..right = offset
            ..width = unit
            ..top = offset
            ..bottom = allOffset;
          break;
        case 2:
          childParentData
            ..left = allOffset
            ..right = offset
            ..bottom = offset
            ..height = unit;
          break;
        case 3:
          childParentData
            ..left = offset
            ..width = unit
            ..top = allOffset
            ..bottom = offset;
          break;
        default:
          // TODO 这里要倒序
          final double centerOffset = math.min(unit, unit * childAspectRatio) + offset;
          childParentData
            ..left = centerOffset
            ..right = centerOffset
            ..top = centerOffset
            ..bottom = centerOffset;
          // TODO 第五个之后先取消布局和重绘
          childParentData.nextSibling = null;
      }

      child = childParentData.nextSibling;
      index++;
    }

    super.performLayout();
  }
}
