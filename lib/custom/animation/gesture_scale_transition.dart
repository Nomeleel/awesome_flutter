import 'package:flutter/widgets.dart';

class GestureScaleTransition extends StatefulWidget {
  const GestureScaleTransition({
    Key key,
    this.duration = const Duration(milliseconds: 300),
    this.minScale = 0.92,
    this.maxScale = 1.0,
    this.callBack,
    this.child,
  }) : super(key: key);

  final Duration duration;
  final double minScale;
  final double maxScale;
  final void Function() callBack;
  final Widget child;

  @override
  _GestureScaleTransitionState createState() => _GestureScaleTransitionState();
}

class _GestureScaleTransitionState extends State<GestureScaleTransition>
    with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _scale;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scale = Tween<double>(
      begin: widget.maxScale,
      end: widget.minScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callBack();
      },
      onPanDown: (e) {
        _controller.forward();
      },
      onPanStart: (e) {
        _controller.forward();
      },
      onPanCancel: () {
        _controller.reverse();
      },
      onPanEnd: (e) {
        _controller.reverse();
        widget.callBack();
      },
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
