import 'package:flutter/widgets.dart';

class ScrollViewJumpTop extends StatefulWidget {
  ScrollViewJumpTop({
    Key? key,
    required this.child,
    this.triggerHeight = 777.777,
    this.jumpTopBuilder,
  }) : super(key: key);

  final Widget child;
  final double triggerHeight;
  final WidgetBuilder? jumpTopBuilder;

  @override
  _ScrollViewJumpTopState createState() => _ScrollViewJumpTopState();
}

class _ScrollViewJumpTopState extends State<ScrollViewJumpTop> with TickerProviderStateMixin {
  ScrollableState? _scrollableState;
  final ValueNotifier<bool> _isShowJumpTop = ValueNotifier<bool>(false);
  late AnimationController _jumpTopAnimationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 200),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((_scrollableState = findScrollableState()) != null) {
        _isShowJumpTop.addListener(valueChangeListener);
        _scrollableState?.position
          ?..removeListener(scrollListener)
          ..addListener(scrollListener);
      }
    });
  }

  ScrollableState? findScrollableState() {
    ScrollableState? result;
    void find(Element element) {
      if (element is StatefulElement && element.state is ScrollableState)
        result = element.state as ScrollableState;
      else
        element.visitChildren(find);
    }

    find(context as Element);
    return result;
  }

  void scrollListener() {
    _isShowJumpTop.value = _scrollableState!.position.pixels >= widget.triggerHeight;
  }

  void valueChangeListener() {
    _isShowJumpTop.value ? _jumpTopAnimationController.forward() : _jumpTopAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return widget.jumpTopBuilder == null ? widget.child : withJumpTop();
  }

  Widget withJumpTop() {
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: SlideTransition(
            position: Tween(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ).animate(_jumpTopAnimationController),
            child: jumpTopWidget(),
          ),
        ),
      ],
    );
  }

  Widget jumpTopWidget() {
    return GestureDetector(
      onTap: jumpTop,
      child: widget.jumpTopBuilder?.call(context),
    );
  }

  void jumpTop() {
    _jumpTopAnimationController.reverse();
    _scrollableState!.position.animateTo(
      0.0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _jumpTopAnimationController.dispose();
    super.dispose();
  }
}
