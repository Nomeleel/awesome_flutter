import 'package:flutter/widgets.dart';

/// Cupertino style slide back widget.
class CupertinoSlideBack extends StatelessWidget {
  /// const constructor.
  const CupertinoSlideBack({Key key, this.child, this.onBackCallBack})
      : super(key: key);

  /// The [child] contained by this widget.
  final Widget child;

  /// Callback before back, then pop up page.
  final void Function() onBackCallBack;

  @override
  Widget build(BuildContext context) {
    bool isFromLeftEdge = false;
    return GestureDetector(
      // TODO(Nomeleel): Use IgnorePointer? solve the problem of gesture conflict.
      child: child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (details.globalPosition.dx < 50) {
          isFromLeftEdge = true;
        }
      },
      onHorizontalDragCancel: () {
        isFromLeftEdge = false;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (isFromLeftEdge) {
          if (onBackCallBack != null) {
            onBackCallBack();
          }
          Navigator.of(context).pop();
        }
        isFromLeftEdge = false;
      },
    );
  }
}
