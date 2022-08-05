import 'package:flutter/material.dart';

class MultiTransition extends StatelessWidget {
  const MultiTransition({Key? key, this.child, this.builder}) : super(key: key);
  final Widget? child;
  final WidgetBuilder? builder;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Multi Singlechild

typedef AnimatedWidgetBuilder = Widget Function(BuildContext context, Listenable animation, Widget child);

class MultiAnimatedBuilder extends StatelessWidget {
  const MultiAnimatedBuilder({
    Key? key,
    required this.animation,
    required this.builders,
    required this.child,
  }) : super(key: key);

  final Listenable animation;
  final List<AnimatedWidgetBuilder> builders;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        Widget widget = child!;
        for (var builder in builders) {
          widget = builder(context, animation, widget);
        }
        return widget;
      },
      child: child,
    );
  }
}

typedef WidgetBuilder = Widget Function(BuildContext context, Widget child);

class MultiBuilder extends StatelessWidget {
  const MultiBuilder({
    Key? key,
    required this.animation,
    required this.builders,
    required this.child,
  }) : super(key: key);

  final Listenable animation;
  final List<WidgetBuilder> builders;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget widget = child!;
    for (var builder in builders) {
      widget = builder(context, widget);
    }
    return widget;
  }
}

// 添加可在中间插入的builder