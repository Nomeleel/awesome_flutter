import 'package:flutter/material.dart';

import '../widget/scroll_float_view.dart';

class ScrollViewFloatView extends StatefulWidget {
  const ScrollViewFloatView({Key? key}) : super(key: key);

  @override
  State<ScrollViewFloatView> createState() => _ScrollViewFloatViewState();
}

class _ScrollViewFloatViewState extends State<ScrollViewFloatView> {
  List<Widget> children(double height) => [
        Container(height: height + 500, color: Colors.amber),
        Container(
          margin: const EdgeInsets.all(10),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ScrollFloatBox(
            height: 200,
            childBuilder: (BuildContext context) => FlutterLogo(),
            animatedBuilder: (context, animated, child) {
              return Align(
                alignment: Alignment(0, animated * 2 - 1),
                child: Container(
                  width: 70,
                  height: 70,
                  color: Colors.purple,
                ),
              );
            },
          ),
        ),
        ScrollFloatContainer(
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
        ScrollFloatContainer(
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
