import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollViewFloatView extends StatefulWidget {
  const ScrollViewFloatView({Key? key}) : super(key: key);

  @override
  State<ScrollViewFloatView> createState() => _ScrollViewFloatViewState();
}

class _ScrollViewFloatViewState extends State<ScrollViewFloatView> {
  List<Widget> children(double height) => [
        Container(height: height + 500, color: Colors.amber),
        ScrollFloatView(
          containerHeight: height * 3,
          floatOut: true,
          childBuilder: (BuildContext context) => FlutterLogo(),
          animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
            return Opacity(
              opacity: 1,
              child: Center(
                child: Container(
                  height: childHeight,
                  color: ColorTween(begin: Colors.amber, end: Colors.purple).lerp(animatedIn)!,
                  alignment: Alignment(animated * 2 - 1, animatedIn * 2 - 1),
                  child: Stack(
                    children: [
                      child!,
                      // Text('$animatedIn'),
                      Text('$animatedOut')
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        ScrollFloatView(
          containerHeight: height * 3,
          floatIn: true,
          childBuilder: (BuildContext context) => CircularProgressIndicator(),
          animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
            return Transform.scale(
              scale: 1 - animatedOut,
              alignment: Alignment.bottomCenter,
              child: Container(
                height: childHeight,
                color: ColorTween(begin: Colors.white, end: Colors.cyan).lerp(animatedIn)!.withOpacity(animatedIn),
                alignment: Alignment(animated * 2 - 1, 0),
                child: child,
              ),
            );
          },
        ),
      ];

  Widget buildInCustomScrollView(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ...children(height).map((e) => SliverToBoxAdapter(child: e)),
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

  @override
  Widget build(BuildContext context) {
    // return buildInCustomScrollView(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ...children(height),
          for (int index = 0; index < 20; index++)
            Container(
              height: 100,
              color: Colors.primaries[index % Colors.primaries.length],
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
    final scrollable = Scrollable.of(context);
    if (scrollable == null) return SizedBox.shrink();
    final position = scrollable.position;

    double? start, resetHeight;
    return SizedBox(
      height: containerHeight,
      child: AnimatedBuilder(
        // TODO:  Refine Granularity.
        animation: position,
        builder: (ctx, child) {
          start ??= _startOffsetInScrollView(context, position);
          if (start == null) return SizedBox.shrink();

          final viewportDimension = position.viewportDimension;
          resetHeight ??= (childHeight?.clamp(0, viewportDimension) ?? viewportDimension);
          final animatedHeight = containerHeight - viewportDimension;
          final offset = position.pixels - start!;

          if (offset < -viewportDimension || offset > containerHeight) return SizedBox.shrink();

          double animatedIn = 0, animated = 0, animatedOut = 0;
          double float = offset / animatedHeight;
          if (offset >= -viewportDimension) {
            animatedIn = clampDouble((offset + viewportDimension) / viewportDimension, 0.0, 1.0);
          }
          if (offset >= 0) {
            animated = clampDouble(float, 0.0, 1.0);
          }
          if (offset >= animatedHeight) {
            animatedOut = clampDouble((offset - animatedHeight) / viewportDimension, 0.0, 1.0);
          }

          double align = (float < 0 && !floatIn) ? 0 : ((float > 1 && !floatOut) ? 1 : float);

          return Align(
            alignment: Alignment(0, align * 2 - 1),
            child: SizedBox(
              height: viewportDimension,
              child: animatedBuilder(context, animatedIn, animated, animatedOut, resetHeight!, child),
            ),
          );
        },
        child: childBuilder(context),
      ),
    );
  }

  double? _startOffsetInScrollView(BuildContext context, ScrollPosition position) => position.startOffset(context);
}

extension ScrollPositionExtension on ScrollPosition {
  double? startOffset(BuildContext context) {
    RenderObject? object = context.findRenderObject();
    if (object != null) {
      return RenderAbstractViewport.of(object)
          ?.getOffsetToReveal(object, 0.0)
          .offset
          .clamp(minScrollExtent, maxScrollExtent);
    }
    return null;
  }
}
