import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FakeOverflowBox extends SingleChildRenderObjectWidget {
  const FakeOverflowBox({
    Key? key,
    this.fakeHeight,
    required Widget child,
  }) : super(key: key, child: child);

  final double? fakeHeight;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderFakeOverflowBox(fakeHeight: fakeHeight);

  @override
  void updateRenderObject(BuildContext context, covariant RenderFakeOverflowBox renderObject) {
    renderObject..fakeHeight = fakeHeight;
  }
}

class RenderFakeOverflowBox extends RenderProxyBox {
  RenderFakeOverflowBox({required this.fakeHeight});

  double? fakeHeight;

  @override
  void performLayout() {
    child?.layout(constraints);
    size = Size(constraints.maxWidth, fakeHeight ?? constraints.maxHeight);
  }
}

class SliverFakeOverflow extends SingleChildRenderObjectWidget {
  const SliverFakeOverflow({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFakeOverflow createRenderObject(BuildContext context) => RenderSliverFakeOverflow();
}

class RenderSliverFakeOverflow extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent = 120.0;
    // switch (constraints.axis) {
    //   case Axis.horizontal:
    //     childExtent = child.size.width;
    //     break;
    //   case Axis.vertical:
    //     childExtent = child.size.height;
    //     break;
    // }
    // assert(childExtent != null);
    // final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double paintedChildSize = 120.0;
    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}
