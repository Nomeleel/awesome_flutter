import '/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class CustomTabBarView extends StatefulWidget {
  const CustomTabBarView({Key? key}) : super(key: key);

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView> with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 3, vsync: this);
  late final pageController = PageController();

  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    // final controller = TabController(length: length, vsync: vsync)
    // final size = MediaQuery.of(context).size;

    // print('value: ------$value');
    // print('value * 2 - 1: -----${value * 2 - 1}');
    // print('tween value: ------${Tween(begin: -1.0, end: 1.0).transform(value)}');

    return ScaffoldView(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // CupertinoSegmentedControl(
          //   // groupValue: 2,
          //   children: {
          //     1: Container(height: 50, width: 50, margin: const EdgeInsets.all(10), color: Colors.amber),
          //     2: Container(height: 60, width: 60, margin: const EdgeInsets.all(10), color: Colors.pink),
          //   },
          //   onValueChanged: (value) {
          //     print(value);
          //   },
          // ),
          // TabBarView(
          //   controller: tabController,
          //   children: List.generate(tabController.length, ((index) => Container(color: Colors.primaries[3 + index]))),
          // ),
          PageView(
            controller: pageController,
            children: List.generate(tabController.length, ((index) => Container(color: Colors.primaries[3 + index]))),
          ),
          // Slider(value: .2, onChanged: (value) {}),
          // CustomTabBar(controller: tabController, pageController: pageController),

          Container(
            width: 350,
            color: Colors.blue,
            alignment: Alignment(((value * 2 - 1.0)).clamp(-1.0, 1.0), 0),
            child: GestureDetector(
              onTap: () {},
              // onHorizontalDragUpdate: (details) {
              //   setState(() {
              //     value += details.primaryDelta! / (size.width - 50);
              //   });
              // },
              // 100 / 10
              // offset 45
              // 5
              onLongPressStart: (details) {
                offset = details.localPosition.dx;
                print(offset);
              },
              onLongPressMoveUpdate: (details) {
                // print(details.globalPosition);
                final delta = details.localPosition.dx - offset;
                print(delta);
                offset = details.localPosition.dx;
                setState(() {
                  value += (delta / 320);
                });
              },
              child: Container(
                width: 30,
                height: 20,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  late double offset;
}

class CustomTabBar extends StatefulWidget {
  CustomTabBar({Key? key, required this.controller, required this.pageController}) : super(key: key);

  final TabController controller;
  final PageController pageController;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.controller.addListener(() {
      // print(tabController.index);
      // print(tabController.offset);
    });
    widget.controller.animation?.addListener(() {
      // print(tabController.animation?.value);
      // print(widget.controller.offset);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      width: 210,
      // margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        // border: Border.all(width: 5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Container(
          //   margin: const EdgeInsets.all(5.0),
          //   // color: Colors.amber,
          //   decoration: BoxDecoration(
          //     color: Colors.amber,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: TabBar(
          //     controller: widget.controller,
          //     indicator: BoxDecoration(
          //         // color: Colors.purple,
          //         // borderRadius: BorderRadius.circular(20),
          //         ),
          //     tabs: List.generate(widget.controller.length, (index) => Tab(text: '$index')),
          //   ),
          // ),
          _buildTabBar(),
          // ClipPath(
          //   clipper: TabClipper(listenable: widget.controller.animation!),
          //   child: _buildTabBar(Colors.purple, Colors.white),
          // ),
          Transform.scale(
            // scale: (70 + 2) / 70,
            scale: 1.05,
            child: ClipPath(
              clipper: TabClipper(listenable: widget.controller.animation!, listenable2: widget.pageController),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print('object');
                },
                onHorizontalDragUpdate: (details) {
                  // print(details.primaryDelta);
                  // print(widget.controller.offset);
                  // print(widget.controller.animation?.value);
                  // widget.controller.animation!.drive(child);

                  // widget.controller.offset += details.primaryDelta ?? 0;

                  widget.pageController
                      .jumpTo(widget.pageController.offset + (details.primaryDelta ?? 0) * width / 210);
                },
                child: _buildTabBar(Colors.purple, Colors.white),
              ),
            ),
          ),
          // ClipPath(
          //   clipper: TabClipper(listenable: widget.controller.animation!),
          //   child: Container(color: Colors.purple, child: _buildTabBar()),
          // ),
          // Container(color: Colors.blue),
          // ValueListenableBuilder(
          //   valueListenable: widget.controller.animation!,
          //   builder: (BuildContext context, double value, Widget? child) {
          //     return Align(
          //       alignment: Alignment((value / (widget.controller.length - 1)) * 2 - 1, 0),
          //       child: child,
          //     );
          //   },
          //   child: Container(
          //     height: 50,
          //     width: 60,
          //     decoration: BoxDecoration(
          //       color: Colors.pink,
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTabBar([Color color = Colors.amber, Color fontColor = Colors.black]) {
    return Container(
      color: color,
      child: Row(
        children: List.generate(
          widget.controller.length,
          (index) => Expanded(child: Center(child: Text('$index', style: TextStyle(color: fontColor, fontSize: 30)))),
        ),
      ),
    );
    // return TabBar(
    //   controller: widget.controller,
    //   indicator: BoxDecoration(
    //       // color: Colors.purple,
    //       // borderRadius: BorderRadius.circular(20),
    //       ),
    //   tabs: List.generate(widget.controller.length, (index) => Tab(text: '$index')),
    // );
  }
}

class TabClipper extends CustomClipper<Path> {
  const TabClipper({required this.listenable, required this.listenable2}) : super(reclip: listenable2);

  final Animation<double> listenable;
  final PageController listenable2;

  final width = 70.0;

  @override
  Path getClip(Size size) {
    // print(listenable.value);
    final left = width * listenable2.page!;
    // print(left);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(left, 0, left + width, size.height),
        Radius.circular(20),
      ));
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;
}
