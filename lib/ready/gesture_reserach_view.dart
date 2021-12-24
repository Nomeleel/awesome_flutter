import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureResearchView extends StatefulWidget {
  GestureResearchView({Key? key}) : super(key: key);

  @override
  _GestureResearchViewState createState() => _GestureResearchViewState();
}

class _GestureResearchViewState extends State<GestureResearchView> with SingleTickerProviderStateMixin {
  late TabController _controller = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Research'),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          TabBar(
            controller: _controller,
            tabs: [
              Tab(text: 'A'),
              Tab(text: 'B'),
              Tab(text: 'C'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                GestureStack(),
                SubTabView(),
                Container(
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubTabView extends StatefulWidget {
  SubTabView({Key? key}) : super(key: key);

  @override
  _SubTabViewState createState() => _SubTabViewState();
}

class _SubTabViewState extends State<SubTabView> with SingleTickerProviderStateMixin {
  late TabController _controller = TabController(length: 3, vsync: this)
    ..removeListener(listener)
    ..addListener(listener);
  final ScrollPhysics _physics = BouncingScrollPhysics();

  void addListener() {
    _controller
      ..removeListener(listener)
      ..addListener(listener);
  }

  void listener() {
    print(_controller.offset);
    if (_controller.offset < 0) {
      print(_controller.offset);
      //_controller.removeListener(listener);
      _physics.applyTo(NeverScrollableScrollPhysics());
      // setState(() {
      //   _physics = NeverScrollableScrollPhysics();
      // });
      //addListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _controller,
          tabs: [
            Tab(text: '1'),
            Tab(text: '2'),
            Tab(text: '3'),
          ],
        ),
        Expanded(
          child: RawGestureDetector(
            gestures: {
              TabViewEagerGestureRecognizer: GestureRecognizerFactoryWithHandlers<TabViewEagerGestureRecognizer>(
                () => TabViewEagerGestureRecognizer(),
                (TabViewEagerGestureRecognizer instance) {},
              )
            },
            child: TabBarView(
              controller: _controller,
              physics: _physics,
              children: <Widget>[
                Container(
                  color: Colors.purple,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.cyan,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TabViewEagerGestureRecognizer extends EagerGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    print(event);
    startTrackingPointer(event.pointer, event.transform);
    resolve(GestureDisposition.rejected);
    stopTrackingPointer(event.pointer);
  }
}

// ignore: must_be_immutable
class TabViewScrollPhysics extends ClampingScrollPhysics {
  TabViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  TabViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TabViewScrollPhysics(parent: buildParent(ancestor));
  }

  bool _allowImplicitScrolling = true;

  @override
  bool get allowImplicitScrolling => _allowImplicitScrolling;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= position.minScrollExtent) // underscroll
      print('set _allowImplicitScrolling = false');
    _allowImplicitScrolling = false;
    return super.applyBoundaryConditions(position, value);
  }
}

// 使用Listener监听事件
// 层叠组件同时响应事件有两种实现方式
// 1. 改写RenderStack的hitTestChildren，使其两个都可以命中
// 2. 最上层接受事件后，通过点击位置，判定下层组件是否可以点击到
// 同时响应后，不同手势也会冲突
// 滑动和点击事件都会响应tap事件，可以通过up和down中point位置得出，相同是点击，反之是滑动
class GestureStack extends StatefulWidget {
  GestureStack({Key? key}) : super(key: key);

  @override
  _GestureStackState createState() => _GestureStackState();
}

class _GestureStackState extends State<GestureStack> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        //print('Listener onPointerUp');
      },
      child: Stack(
        children: [
          for (int i = 0; i < 3; i++)
            Positioned.directional(
              start: i * 100.0,
              textDirection: TextDirection.ltr,
              child: Listener(
                onPointerDown: (e) {
                  print('Stack Item index: $i');
                },
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.primaries[i],
                ),
              ),
            ),
          // Listener(
          //   onPointerDown: (e) {
          //     print('Container 1');
          //   },
          //   child: Container(
          //     width: 100.0,
          //     height: 100.0,
          //     color: Colors.purple,
          //     child: const Text('Container 1'),
          //   ),
          // ),
          PageView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print('PageView index: $index');
                },
                child: Container(
                  color: Colors.primaries[index].withOpacity(0.2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/*
// 改写这里
extension RenderStackHitTest on RenderStack {
  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {}

  bool defaultHitTestChildren(BoxHitTestResult result, {Offset position}) {}
}
*/

// 研究层级页面(Stack)手势穿透问题
class GestureStackTest extends StatefulWidget {
  GestureStackTest({Key? key}) : super(key: key);

  @override
  _GestureStackTestState createState() => _GestureStackTestState();
}

class _GestureStackTestState extends State<GestureStackTest> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        //print('Listener onPointerUp');
      },
      child: Stack(
        children: [
          Listener(
            onPointerDown: (e) {
              print('Container');
            },
            child: Container(
              width: 100.0,
              height: 100.0,
              alignment: Alignment.center,
              color: Colors.purple,
            ),
          ),
          Listener(
            onPointerDown: (e) {
              print('Stack');
            },
            child: Stack(
              children: [
                for (int i = 0; i < 3; i++)
                  Positioned.directional(
                    start: i * 100.0,
                    textDirection: TextDirection.ltr,
                    child: GestureDetector(
                      onTap: () {
                        print('Stack Item index: $i');
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        color: Colors.primaries[i],
                      ),
                    ),
                    // child: Listener(
                    //   onPointerDown: (e) {
                    //     print('Stack Item index: $i');
                    //   },
                    //   child: Container(
                    //     width: 100.0,
                    //     height: 100.0,
                    //     color: Colors.primaries[i],
                    //   ),
                    // ),
                  )
              ],
            ),
          ),
          Listener(
            onPointerDown: (e) {
              print('Container 1');
            },
            child: Container(
              width: 100.0,
              height: 100.0,
              color: Colors.purple,
              child: const Text('Container 1'),
            ),
          ),
          RawGestureDetector(
            gestures: {
              IgnoreTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<IgnoreTapGestureRecognizer>(
                () => IgnoreTapGestureRecognizer(),
                (IgnoreTapGestureRecognizer instance) {
                  print('IgnoreTapGestureRecognizer instance');
                },
              )
            },
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print('PageView index: $index');
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
          // Listener(
          //   onPointerDown: (e) {
          //     print('PageView');
          //   },
          //   child: PageView.builder(
          //     itemCount: 3,
          //     itemBuilder: (BuildContext context, int index) {
          //       // return GestureDetector(
          //       //   onTap: () {
          //       //     print('PageView index: $index');
          //       //   },
          //       //   child: Container(
          //       //     color: Colors.transparent,
          //       //   ),
          //       // );
          //       return RawGestureDetector(
          //         gestures: {
          //           IgnoreTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<IgnoreTapGestureRecognizer>(
          //             () => IgnoreTapGestureRecognizer(),
          //             (IgnoreTapGestureRecognizer instance) {
          //               instance.onTap = () {
          //                 print('IgnoreTapGestureRecognizer Tap');
          //               };
          //             },
          //           )
          //         },
          //         child: Listener(
          //           onPointerUp: (e) {
          //             print('PageView index: $index');
          //             print('--------------------------------');
          //             print('onPointerUp: ${e.position.dx}');
          //           },
          //           onPointerDown: (e) {
          //             print('PageView index: $index');
          //             print('onPointerDown: ${e.position.dx}');
          //             print('--------------------------------');
          //           },
          //           child: Container(
          //             color: Colors.primaries[index].withOpacity(0.2),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // Listener(
          //   onPointerDown: (e) {
          //     print('Container 2');
          //   },
          //   child: Container(
          //     width: 150.0,
          //     height: 150.0,
          //     alignment: Alignment.center,
          //     color: Colors.green,
          //     child: const Text('Container 2'),
          //   ),
          // ),
          // RawGestureDetector(
          //   gestures: {
          //     StackEagerGestureRecognizer: GestureRecognizerFactoryWithHandlers<StackEagerGestureRecognizer>(
          //       () => StackEagerGestureRecognizer(),
          //       (StackEagerGestureRecognizer instance) {
          //         print('StackEagerGestureRecognizer instance');
          //       },
          //     )
          //   },
          //   child: Container(
          //     width: 110.0,
          //     height: 110.0,
          //     color: Colors.amber,
          //   ),
          // ),
          // RawGestureDetector(
          //   gestures: {
          //     IgnoreTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<IgnoreTapGestureRecognizer>(
          //       () => IgnoreTapGestureRecognizer(),
          //       (IgnoreTapGestureRecognizer instance) {
          //         print('IgnoreTapGestureRecognizer instance');
          //         instance.onTapDown = (e) {
          //           print('IgnoreTapGestureRecognizer onTapDown');
          //         };
          //       },
          //     )
          //   },
          //   child: Container(
          //     width: 100.0,
          //     height: 100.0,
          //     alignment: Alignment.center,
          //     color: Colors.purple,
          //     child: const Text('Container 3'),
          //   ),
          // ),
          Listener(
            onPointerDown: (e) {
              print('Container 3');
            },
            child: Container(
              width: 100.0,
              height: 100.0,
              alignment: Alignment.center,
              color: Colors.purple,
              child: const Text('Container 3'),
            ),
          ),
          // RawGestureDetector(
          //   gestures: {
          //     AbsorbTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<AbsorbTapGestureRecognizer>(
          //       () => AbsorbTapGestureRecognizer(),
          //       (AbsorbTapGestureRecognizer instance) {
          //         print('AbsorbTapGestureRecognizer instance');
          //         instance.onTap = () {
          //           print('Container 3');
          //         };
          //       },
          //     )
          //   },
          //   child: Container(
          //     width: 100.0,
          //     height: 100.0,
          //     color: Colors.purple,
          //     child: const Text('Container 3'),
          //   ),
          // ),
          Listener(
            onPointerDown: (e) {
              print('Container 4');
            },
            child: Container(
              width: 100.0,
              height: 100.0,
              alignment: Alignment.center,
              color: Colors.purple,
              child: const Text('Container 4'),
            ),
          ),
          // 点击中间同时相应两个Container的点击事件
          // RawGestureDetector(
          //   gestures: {
          //     AbsorbTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<AbsorbTapGestureRecognizer>(
          //       () => AbsorbTapGestureRecognizer(),
          //       (AbsorbTapGestureRecognizer instance) {
          //         print('AbsorbTapGestureRecognizer instance');
          //         instance.onTap = () {
          //           print('Container 5');
          //         };
          //       },
          //     )
          //   },
          //   child: Container(
          //     width: 321.0,
          //     height: 321.0,
          //     alignment: Alignment.center,
          //     color: Colors.purple,
          //     child: GestureDetector(
          //       onTap: () {
          //         print('Container 6');
          //       },
          //       child: Container(
          //         width: 123.0,
          //         height: 123.0,
          //         color: Colors.indigo,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class StackEagerGestureRecognizer extends EagerGestureRecognizer {
  // @override
  // void addAllowedPointer(PointerDownEvent event) {
  //   print(event);
  //   startTrackingPointer(event.pointer, event.transform);
  //   resolve(GestureDisposition.rejected);
  //   stopTrackingPointer(event.pointer);
  // }

  // @override
  // void rejectGesture(int pointer) {
  //   print('StackEagerGestureRecognizer rejectGesture');
  //   acceptGesture(pointer);
  // }

  @override
  void acceptGesture(int pointer) {
    print('StackEagerGestureRecognizer acceptGesture');
    rejectGesture(pointer);
  }
}

class IgnoreTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void acceptGesture(int pointer) {
    rejectGesture(pointer);
  }

  // @override
  // void addAllowedPointer(PointerDownEvent event) {
  //   print(event);
  //   startTrackingPointer(event.pointer, event.transform);
  //   resolve(GestureDisposition.accepted);
  //   stopTrackingPointer(event.pointer);
  // }

  // @override
  // void addPointer(PointerDownEvent event) {
  //   print('addPointer');
  //   handleNonAllowedPointer(event);
  //   super.addPointer(event);
  // }
}

class AbsorbTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
