import 'package:flutter/material.dart';

class ScrollViewFloatView extends StatefulWidget {
  const ScrollViewFloatView({Key? key}) : super(key: key);

  @override
  State<ScrollViewFloatView> createState() => _ScrollViewFloatViewState();
}

class _ScrollViewFloatViewState extends State<ScrollViewFloatView> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    final height = 1000.0;
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: height)),
          // SliverToBoxAdapter(
          //   child: AnimatedBuilder(
          //     animation: controller,
          //     builder: (context, child) {
          //       // if (!controller.hasClients) return child!;
          //       final offset = (controller.offset - height1).clamp(0.0, 400.0);
          //       return Padding(
          //         padding: EdgeInsets.only(top: offset),
          //         child: Opacity(
          //           opacity: 1 - offset / 800,
          //           child: child,
          //         ),
          //       );
          //     },
          //     child: Container(
          //       height: 400.0,
          //       color: Colors.amber,
          //     ),
          //   ),
          // ),
          // SliverLayoutBuilder(
          //   builder: (context, constraints) {
          //     print(constraints);
          //     return SliverToBoxAdapter(
          //       child: Container(
          //         height: 222,
          //         color: Colors.pink,
          //       ),
          //     );
          //   },
          // ),
          SliverToBoxAdapter(
            child: ScrollFloatView(
              // childHeight: 200,
              containerHeight: 2000,
              childBuilder: (BuildContext context) => CircularProgressIndicator(),
              animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
                return Transform.scale(
                  scale: 1 - animatedOut,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: childHeight,
                    color: ColorTween(begin: Colors.amber, end: Colors.purple).lerp(animatedIn)!.withOpacity(.5),
                    alignment: Alignment(animated * 2 - 1, 0),
                    child: child,
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                height: 100,
                color: Colors.primaries[index % Colors.primaries.length],
              ),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

typedef AnimatedValueWidgetBuilde = Widget Function(
  BuildContext context,
  double animatedIn,
  double animated,
  double animatedOut,
  double childHeight,
  Widget? child,
);

class ScrollFloatView extends StatelessWidget {
  const ScrollFloatView({
    Key? key,
    this.childHeight,
    required this.containerHeight,
    required this.animatedBuilder,
    required this.childBuilder,
  }) : super(key: key);

  final double? childHeight;
  final double containerHeight;
  final AnimatedValueWidgetBuilde animatedBuilder;
  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    final scrollable = Scrollable.of(context)!;
    final position = scrollable.position;

    double? start, resetHeight;
    double animatedIn = 0, animated = 0, animatedOut = 0;

    return SizedBox(
      height: containerHeight,
      child: AnimatedBuilder(
        // TODO:  Refine Granularity.
        animation: position,
        builder: (ctx, child) {
          if (!position.hasViewportDimension) return SizedBox.shrink();
          start ??= _startOffsetInScrollView(context, scrollable);
          final viewportDimension = position.viewportDimension;
          resetHeight ??= childHeight?.clamp(0, viewportDimension) ?? viewportDimension;
          final animatedHeight = containerHeight - resetHeight!;
          final offset = position.pixels - start!;
          if (offset < 0 && offset > -viewportDimension) {
            animatedIn = ((offset + viewportDimension) / viewportDimension).clamp(0.0, 1.0);
          } else if (offset < animatedHeight) {
            animated = (offset / animatedHeight).clamp(0.0, 1.0);
          } else {
            animatedOut = ((offset - animatedHeight) / resetHeight!).clamp(0.0, 1.0);
          }

          return Align(
            alignment: Alignment(0, animated * 2 - 1),
            child: animatedBuilder(context, animatedIn, animated, animatedOut, resetHeight!, child),
          );
        },
        child: childBuilder(context),
      ),
    );
  }

  double _startOffsetInScrollView(BuildContext context, ScrollableState scrollable) {
    final box = context.findRenderObject() as RenderBox?;
    final offset = box?.localToGlobal(Offset.zero, ancestor: scrollable.context.findRenderObject());
    return offset?.dy ?? 0;
  }
}
