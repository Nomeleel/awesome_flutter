import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FakeOverflowBox extends SingleChildRenderObjectWidget {
  const FakeOverflowBox({
    Key key,
    this.fakeHeight,
    Widget child,
  }) : super(key: key, child: child);

  final double fakeHeight;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFakeOverflowBox(fakeHeight: fakeHeight);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderFakeOverflowBox renderObject) {
    renderObject..fakeHeight = fakeHeight;
  }
}

class RenderFakeOverflowBox extends RenderProxyBox {
  RenderFakeOverflowBox({this.fakeHeight});

  double fakeHeight;

  @override
  void performLayout() {
    child.layout(constraints);
    size = Size(constraints.maxWidth, fakeHeight ?? constraints.maxHeight);
  }
}
