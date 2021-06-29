import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/scaffold_view.dart';
import '../widget/tab_view.dart';

class CustomScrollViewTestView extends StatelessWidget {
  const CustomScrollViewTestView({Key key}) : super(key: key);

  final EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 22.0);
  final int itemCount = 77;
  final double itemHeight = 77.0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Custom Scroll Test View',
      body: TabView(
        tabs: [
          'Custom Scroll View',
        ],
        children: [
          customScrollView(context),
        ],
      ),
    );
  }

  Widget customScrollView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildTitle('Title 1'),
        ),
        SliverFixedExtentList(
          itemExtent: itemHeight,
          delegate: _getBuilderDelegate(),
        ),
        _getPersistentHeader(2),
        SliverGrid(
          gridDelegate: _getGridDelegate(),
          delegate: _getBuilderDelegate(),
        ),
        _getPersistentHeader(3),
        SliverPadding(
          padding: padding,
          sliver: _buildListView().buildChildLayout(context),
        ),
        _getPersistentHeader(4),
        SliverPadding(
          padding: padding,
          sliver: _buildGridView().buildChildLayout(context),
        ),
      ],
    );
  }

  SliverPersistentHeader _getPersistentHeader(int index) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedSliverPersistentHeaderDelegate(itemHeight, _buildTitle('Title $index')),
    );
  }

  SliverGridDelegate _getGridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 7.0,
      crossAxisSpacing: 7.0,
      childAspectRatio: 0.618,
    );
  }

  SliverChildDelegate _getBuilderDelegate() {
    return SliverChildBuilderDelegate(
      _itemBuilder,
      childCount: itemCount,
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: padding,
      itemExtent: itemHeight,
      itemCount: itemCount,
      itemBuilder: _itemBuilder,
    );
  }

  GridView _buildGridView() {
    return GridView.builder(
      padding: padding,
      gridDelegate: _getGridDelegate(),
      itemCount: itemCount,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return IndexItem(index: index);
  }

  Widget _buildTitle(String title) {
    return Container(
      height: itemHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.purple],
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

class FixedSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const FixedSliverPersistentHeaderDelegate(this.fixedHeight, this.child);

  final double fixedHeight;
  final Widget child;

  @override
  double get maxExtent => fixedHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class IndexItem extends StatefulWidget {
  const IndexItem({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _IndexItemState createState() => _IndexItemState();
}

class _IndexItemState extends State<IndexItem> {
  @override
  Widget build(BuildContext context) {
    print('--------build: ${widget.index}---------');
    return Container(color: Colors.primaries[widget.index % Colors.primaries.length]);
  }
}
