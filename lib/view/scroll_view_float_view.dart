import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
          // Flutter Logo issue
          childBuilder: (BuildContext context) => Container(
            width: 350,
            height: 350,
            alignment: Alignment.center,
            child: FlutterLogo(
              size: 330,
              textColor: Colors.white,
              style: FlutterLogoStyle.horizontal,
            ),
          ),
          animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
            return ColoredBox(
              color: ColorTween(
                begin: Colors.amber,
                end: Colors.purple,
              ).lerp(animatedIn)!.withOpacity(1 - animatedOut),
              child: SplitHalfSlide(
                slide: animatedOut,
                child: Container(
                  height: childHeight,
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: animatedIn,
                    alignment: Alignment(0, 1 - animatedIn),
                    child: ShaderMask(
                      shaderCallback: LinearGradient(
                        begin: Alignment(-animated, -animated),
                        end: Alignment(animated, animated),
                        colors: Colors.primaries,
                      ).createShader,
                      child: child!,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        ScrollFloatContainer(
          containerHeight: height * 3,
          floatIn: true,
          childBuilder: (BuildContext context) => Icon(Icons.flutter_dash, color: Colors.blue[700], size: 200),
          animatedBuilder: (context, animatedIn, animated, animatedOut, childHeight, child) {
            return Transform.scale(
              scale: 1 - animatedOut,
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: childHeight,
                decoration: ShapeDecoration(
                  shape: animatedOut > 0 ? const StadiumBorder() : const RoundedRectangleBorder(),
                  color: ColorTween(begin: Colors.white, end: Colors.cyan).lerp(animated)!.withOpacity(animated),
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (animated > 0)
                      CupertinoActivityIndicator.partiallyRevealed(
                        radius: 350,
                        color: Colors.primaries[(7 * animated).toInt()],
                        progress: animated,
                      ),
                    Transform.scale(
                      scale: double.parse(animatedIn.toStringAsFixed(2)),
                      child: child,
                    ),
                  ],
                ),
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
      body: ScrollConfiguration(
        behavior: ShowScrollBarScrollBehavior(),
        child: ListView(
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
      ),
    );
  }
}

class SplitHalfSlide extends StatelessWidget {
  const SplitHalfSlide({
    super.key,
    required this.child,
    this.slide = 0.0,
  });

  final Widget child;
  final double slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FractionalTranslation(
          translation: Tween<Offset>(begin: Offset.zero, end: Offset(-1, 0)).transform(slide),
          child: ClipRect(
            clipper: const HorizontalHalfClipper(),
            child: child,
          ),
        ),
        FractionalTranslation(
          translation: Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)).transform(slide),
          child: ClipRect(
            clipper: const HorizontalHalfClipper(isLeft: false),
            child: child,
          ),
        ),
      ],
    );
  }
}

class HorizontalHalfClipper extends CustomClipper<Rect> {
  const HorizontalHalfClipper({this.isLeft = true});

  final bool isLeft;

  @override
  Rect getClip(Size size) {
    final half = size.width / 2;
    return Offset(isLeft ? 0 : half, 0) & Size(half, size.height);
  }

  @override
  bool shouldReclip(HorizontalHalfClipper oldClipper) => oldClipper.isLeft != isLeft;
}

class ShowScrollBarScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return CupertinoScrollbar(
      controller: details.controller,
      thickness: 20,
      radius: Radius.circular(10),
      thicknessWhileDragging: 30,
      radiusWhileDragging: Radius.circular(15),
      thumbVisibility: true,
      child: child,
    );
  }
}
