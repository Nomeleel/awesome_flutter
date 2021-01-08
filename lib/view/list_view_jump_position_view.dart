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
      body: Column(
        children: [
          Container(
            height: 222.222,
            color: Colors.purple,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                sliverList(),
                targetSliverList(),
                sliverList(),
                ...List.generate(7, (index) => sliverList()),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverDelegate(
                    minHeight: 40.0,
                    maxHeight: 100.0,
                    child: Container(
                      color: Colors.cyan,
                      child: Center(
                        child: const Text('Title'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
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

  // 这种方式只支持从上跳转到下面， 因为如果锚点在滚动视图上面，位置就会算的不对
  void jump(BuildContext context) {
    ScrollableState scrollableState = Scrollable.of(context);
    if (scrollableState != null) {
      double offset =
          getVectorY(_globalKey.currentContext) - getVectorY(scrollableState.context) + scrollableState.position.pixels;
      print(offset);
      scrollableState?.position?.animateTo(
        math.min(offset, scrollableState.position.maxScrollExtent),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  double getVectorY(BuildContext context) {
    return context.findRenderObject().getTransformTo(null).getTranslation().y;
  }
}

class _SliverDelegate extends SliverPersistentHeaderDelegate {
  _SliverDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
