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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(child: Container(height: height + 500, color: Colors.amber)),
          // SliverToBoxAdapter(
          //   child: ScrollFloatView(
          //     containerHeight: height * 3,
          //     floatOut: true,
          //     childBuilder: (BuildContext context) => FlutterLogo(),
          //     animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
          //       return Opacity(
          //         opacity: 1 - animatedOut,
          //         child: Container(
          //           height: childHeight,
          //           color: ColorTween(begin: Colors.amber, end: Colors.purple).lerp(animatedIn)!,
          //           alignment: Alignment(animated * 2 - 1, 0),
          //           child: child,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          SliverToBoxAdapter(
            child: ScrollFloatView(
              containerHeight: height * 3,
              floatIn: true,
              childBuilder: (BuildContext context) => CircularProgressIndicator(),
              animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
                return Transform.scale(
                  scale: 1 - animatedOut,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: childHeight,
                    color: ColorTween(begin: Colors.white, end: Colors.cyan).lerp(animatedIn)!,
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
    this.floatIn = false,
    this.floatOut = false,
  }) : super(key: key);

  final double? childHeight;
  final double containerHeight;
  final AnimatedValueWidgetBuilde animatedBuilder;
  final WidgetBuilder childBuilder;
  final bool floatIn;
  final bool floatOut;

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
          double align = (offset / animatedHeight);
          if (offset < -viewportDimension || offset > containerHeight) {
            return SizedBox.shrink();
          } else if (offset < 0) {
            animatedIn = ((offset + viewportDimension) / viewportDimension).clamp(0.0, 1.0);
            if (!floatIn) align = 0;
          } else if (offset < animatedHeight) {
            animated = (offset / animatedHeight).clamp(0.0, 1.0);
          } else {
            animatedOut = ((offset - animatedHeight) / resetHeight!).clamp(0.0, 1.0);
            if (!floatOut) align = 1;
          }

          return Align(
            alignment: Alignment(0, align * 2 - 1),
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
