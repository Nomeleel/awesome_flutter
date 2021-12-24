import 'package:flutter/widgets.dart';

/// Cupertino style slide back widget.
class CupertinoSlideBack extends StatelessWidget {
  /// const constructor.
  const CupertinoSlideBack({
    Key? key,
    required this.child,
    this.onBackCallBack,
  }) : super(key: key);

  /// The [child] contained by this widget.
  final Widget child;

  /// Callback before back, then pop up page.
  final void Function()? onBackCallBack;

  @override
  Widget build(BuildContext context) {
    const double edgeOffsetLength = 7.0;
    bool isCanBack = false;
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          child,
          AbsorbPointer(
            child: Container(
              color: const Color(0x00000000),
              width: edgeOffsetLength,
            ),
          ),
        ],
      ),
      onHorizontalDragStart: (DragStartDetails details) {
        if (details.globalPosition.dx < edgeOffsetLength) {
          isCanBack = true;
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (isCanBack && (details.primaryDelta ?? 0) < 0) {
          isCanBack = false;
        }
      },
      onHorizontalDragCancel: () {
        isCanBack = false;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (isCanBack) {
          onBackCallBack?.call();
          Navigator.of(context).pop();
        }
        isCanBack = false;
      },
    );
  }
}
