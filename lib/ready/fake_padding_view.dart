import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widget/scaffold_view.dart';

// 为child外围添加间距，而大小不算入间距，使child按照自己的大小去应用布局，完全不考虑间距。
class FakePaddingView extends StatelessWidget {
  const FakePaddingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Fake Padding View',
      body: Center(
        child: GestureDetector(
          onTap: () {
            print('------Tap------https://www.abc.com');
          },
          child: FakePadding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              height: 77.0,
              width: 77.0,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}

class FakePadding extends SingleChildRenderObjectWidget {
  const FakePadding({
    Key? key,
    this.padding = EdgeInsets.zero,
    required Widget child,
  }) : super(key: key, child: child);

  final EdgeInsetsGeometry padding;

  @override
  RenderFakePadding createRenderObject(BuildContext context) => RenderFakePadding(padding: padding);

  @override
  void updateRenderObject(BuildContext context, RenderFakePadding renderObject) {
    renderObject.padding = padding;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null));
  }
}

class RenderFakePadding extends RenderProxyBox {
  RenderFakePadding({required this.padding});

  EdgeInsetsGeometry padding;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    print(position);
    return super.hitTest(result, position: position);
  }
}
