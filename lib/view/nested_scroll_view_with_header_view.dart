import 'package:flutter/material.dart';

class NestedScrollViewWithHeaderView extends StatefulWidget {
  NestedScrollViewWithHeaderView({Key key}) : super(key: key);

  @override
  _NestedScrollViewWithHeaderViewState createState() => _NestedScrollViewWithHeaderViewState();
}

class _NestedScrollViewWithHeaderViewState extends State<NestedScrollViewWithHeaderView> with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.purple,
            title: Text(
              'NestedScrollView',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: Colors.orange.withOpacity(0.7),
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: TabBar(
                      controller: _controller,
                      tabs: [
                        Tab(
                          text: 'A',
                        ),
                        Tab(
                          text: 'B',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _controller,
        children: [
          CustomScrollView(slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverPersistentHeaderContainerDelegate(),
            ),
            SliverToBoxAdapter(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 80,
                    color: Colors.primaries[index % Colors.primaries.length],
                    alignment: Alignment.center,
                    child: Text(
                      '$index',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                },
                itemCount: 20,
              ),
            )
          ]),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 80,
                color: Colors.primaries[index % Colors.primaries.length],
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            },
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}

class SliverPersistentHeaderContainerDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    print(shrinkOffset);
    print(overlapsContent);
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        'Header',
        style: TextStyle(color: Colors.amber),
      ),
    );
  }

  @override
  double get maxExtent => 120.0;

  @override
  double get minExtent => 120.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
