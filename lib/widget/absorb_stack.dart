// 为子组件添加额外的监听，防止被其他子组件提前命中，而无法传递到下层子组件。
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AbsorbStack extends Stack {
  AbsorbStack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit sizing = StackFit.loose,
    this.absorbIndex = 0,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, alignment: alignment, textDirection: textDirection, fit: sizing, children: children);

  final int absorbIndex;

  @override
  RenderAbsorbStack createRenderObject(BuildContext context) {
    return RenderAbsorbStack(
      absorbIndex: absorbIndex,
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderAbsorbStack renderObject) {
    renderObject
      ..absorbIndex = absorbIndex
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.of(context);
  }
}

class RenderAbsorbStack extends RenderStack {
  RenderAbsorbStack({
    List<RenderBox>? children,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    int absorbIndex = 0,
  }) : _absorbIndex = absorbIndex,
       super(
         children: children,
         alignment: alignment,
         textDirection: textDirection,
       );

  int _absorbIndex;
  int get absorbIndex => _absorbIndex;
  set absorbIndex(value) => _absorbIndex = value;

  RenderBox? _childAtIndex() {
    RenderBox? child = firstChild;
    int i = 0;
    while (child != null && i < _absorbIndex) {
      final StackParentData childParentData = child.parentData as StackParentData;
      child = childParentData.nextSibling;
      i += 1;
    }

    return child;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position }) {
    if (firstChild == null)
      return false;
    RenderBox? child = lastChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData as StackParentData;
      final bool isHit = addWithPaintOffset(result, child, position, childParentData: childParentData);
      if (isHit) {
        // 为指定的子组件添加命中检测
        final RenderBox? absorbChild = _childAtIndex();
        if (absorbChild.hashCode != child.hashCode) {
          addWithPaintOffset(result, absorbChild, position);
        }
        return true;
      }

      child = childParentData.previousSibling;
    }
    return false;
  }

  bool addWithPaintOffset(BoxHitTestResult result, RenderBox? child, Offset position, {StackParentData? childParentData}) {
    childParentData ??= child?.parentData as StackParentData;
    return result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        return child?.hitTest(result, position: transformed) ?? false;
      },
    );
  }
}
