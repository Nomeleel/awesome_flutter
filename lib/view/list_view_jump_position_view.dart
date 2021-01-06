import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ListViewJumpPositionView extends StatefulWidget {
  const ListViewJumpPositionView({Key key}) : super(key: key);

  @override
  _ListViewJumpPositionViewState createState() => _ListViewJumpPositionViewState();
}

class _ListViewJumpPositionViewState extends State<ListViewJumpPositionView> {
  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View Jump Position View'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          sliverList(),
          ...List.generate(77, (index) => sliverList()),
          targetSliverList(),
        ],
      ),
    );
  }

  SliverList sliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          height: 77.77,
          margin: EdgeInsets.all(7.7),
          color: Colors.primaries[index % 15],
          alignment: Alignment.center,
          child: RaisedButton(
            child: const Text('Go'),
            onPressed: () => jump(context),
          ),
        ),
        childCount: 7,
      ),
    );
  }

  SliverList targetSliverList([Key key]) {
    return SliverList(
      key: _globalKey,
      delegate: SliverChildBuilderDelegate(
        (context, index) => Container(
          height: 77.77,
          margin: EdgeInsets.all(7.7),
          color: Colors.purple,
        ),
        childCount: 7,
      ),
    );
  }

  void jump(BuildContext context) {
    ScrollableState scrollableState = Scrollable.of(context);
    if (scrollableState != null) {
      double target = math.min(_globalKey.currentContext.findRenderObject().getTransformTo(null).getTranslation().y,
          scrollableState.position.maxScrollExtent);
      print(target);
      scrollableState?.position?.animateTo(
        target,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }
}
