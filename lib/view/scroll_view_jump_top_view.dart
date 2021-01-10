import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/scroll_view_jump_top.dart';

class ScrollViewJumpTopView extends StatefulWidget {
  const ScrollViewJumpTopView({Key key}) : super(key: key);

  @override
  _ScrollViewJumpTopViewState createState() => _ScrollViewJumpTopViewState();
}

class _ScrollViewJumpTopViewState extends State<ScrollViewJumpTopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll View Jump Top View'),
      ),
      body: ScrollViewJumpTop(
        child: ScrollViewWrap(
          child: ListView.builder(
            itemCount: 77,
            itemBuilder: (BuildContext context, int index) => Container(
              height: 77.77,
              margin: EdgeInsets.all(7.7),
              color: Colors.primaries[index % 16],
              alignment: Alignment.center,
              child: Text('$index'),
            ),
          ),
        ),
        jumpTopBuilder: (BuildContext context) {
          return Container(
            height: 60.0,
            width: 60.0,
            margin: EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: const Icon(Icons.arrow_upward),
          );
        },
      ),
    );
  }
}

class ScrollViewWrap extends StatefulWidget {
  const ScrollViewWrap({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  _ScrollViewWrapState createState() => _ScrollViewWrapState();
}

class _ScrollViewWrapState extends State<ScrollViewWrap> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
