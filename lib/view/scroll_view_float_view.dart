import 'package:awesome_flutter/widget/scaffold_view.dart';
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
    return ScaffoldView(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          // SliverToBoxAdapter(child: SizedBox(height: height)),
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
          SliverToBoxAdapter(child: ScrollFloatView()),
          SliverToBoxAdapter(child: ScrollFloatView()),
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

class ScrollFloatView extends StatelessWidget {
  const ScrollFloatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollable = Scrollable.of(context)!;
    final position = scrollable.position;
    const containerHeight = 817.0 * 3;
    double? start;
    print(position.hasViewportDimension);
    return Container(
      height: containerHeight,
      color: Colors.pink,
      child: AnimatedBuilder(
        animation: position,
        builder: (ctx, child) {
          if (!position.hasViewportDimension) return SizedBox.shrink();
          // TODO: refine
          start ??=
              context.findRenderObject()!.getTransformTo(scrollable.context.findRenderObject()).getTranslation().y;
          final height = position.viewportDimension;
          // final animation = ((position.pixels - start!) / (containerHeight - height)).clamp(0.0, 1.0);
          final animation = ((position.pixels - start!) / (height * 2)).clamp(0.0, 1.0);
          print('start: $start');

          return Align(
            alignment: Alignment(0, animation * 2 - 1),
            // heightFactor: 3.0,
            child: Container(
              height: height,
              color: ColorTween(begin: Colors.amber, end: Colors.purple).lerp(animation)!.withOpacity(.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
          // return Padding(
          //   padding: EdgeInsets.only(top: 400 - (controller.offset - height1).clamp(0, 400)),
          //   child: child,
          // );
        },
        // child: Container(
        //   height: height,
        //   color: Colors.amber,
        // ),
      ),
    );
  }
}
