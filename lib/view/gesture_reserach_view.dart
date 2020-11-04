import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GestureResearchView extends StatefulWidget {
  GestureResearchView({Key key}) : super(key: key);

  @override
  _GestureResearchViewState createState() => _GestureResearchViewState();
}

class _GestureResearchViewState extends State<GestureResearchView> with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

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
                Container(
                  color: Colors.white,
                ),
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
  SubTabView({Key key}) : super(key: key);

  @override
  _SubTabViewState createState() => _SubTabViewState();
}

class _SubTabViewState extends State<SubTabView> with SingleTickerProviderStateMixin {
  TabController _controller;
  ScrollPhysics _physics;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _physics = BouncingScrollPhysics();
    addListener();
  }

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
  TabViewScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  TabViewScrollPhysics applyTo(ScrollPhysics ancestor) {
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
