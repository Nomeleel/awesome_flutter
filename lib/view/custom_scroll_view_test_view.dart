import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widget/scaffold_view.dart';
import '../widget/sliver_to_box_adapter.dart';
import '../widget/tab_view.dart';

class CustomScrollViewTestView extends StatelessWidget {
  const CustomScrollViewTestView({Key? key}) : super(key: key);

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
          'Single Scroll View',
        ],
        children: [
          _customScrollView(context),
          _singleScrollView(context),
        ],
      ),
    );
  }

  Widget _customScrollView(BuildContext context) {
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
        SliverToBoxScrollViewAdapter(
          boxScrollView: _buildListView(),
        ),
        _getPersistentHeader(4),
        SliverToBoxScrollViewAdapter(
          boxScrollView: _buildGridView(),
        ),
        SliverPadding(
          padding: padding,
          sliver: _buildGridView().buildChildLayout(context),
        ),
        // Test computeMaxScrollOffset
        SliverLayoutBuilder(builder: (sliverContext, sliverConstraints) {
          final SliverGrid sliverGrid = _buildGridView().buildChildLayout(context) as SliverGrid;
          final screenWidth = MediaQuery.of(context).size.width;
          print('--------------------');

          print(sliverGrid.estimateMaxScrollOffset(sliverConstraints, 0, itemCount - 1, 0, 0));

          final SliverGridDelegateWithFixedCrossAxisCount gridDelegate = _getGridDelegate();

          print(gridDelegate.getLayout(sliverConstraints).computeMaxScrollOffset(itemCount));

          final fakeSliverConstraints = SliverConstraintsExtension.empty.copyWith(crossAxisExtent: screenWidth);
          print(gridDelegate.getLayout(fakeSliverConstraints).computeMaxScrollOffset(itemCount));

          print(gridDelegate.computeMaxScrollOffset(childCount: itemCount, crossAxisExtent: screenWidth));

          print('--------------------');

          return sliverGrid;
        }),
      ],
    );
  }

  // 不推荐 仅作为演示才使用
  Widget _singleScrollView(BuildContext context) {
    final children = [
      _buildTitle('Title 1'),
      _buildListView(),
      _buildTitle('Title 2'),
      _buildGridView(),
    ];

    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (_, int index) => children[index],
    );
  }

  SliverPersistentHeader _getPersistentHeader(int index) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedSliverPersistentHeaderDelegate(itemHeight, _buildTitle('Title $index')),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _getGridDelegate() {
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
      itemExtent: itemHeight,
      itemCount: itemCount,
      itemBuilder: _itemBuilder,
      // 以下属性在转换为Sliver后无效
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  GridView _buildGridView() {
    return GridView.builder(
      gridDelegate: _getGridDelegate(),
      itemCount: itemCount,
      itemBuilder: _itemBuilder,
      // 以下属性在转换为Sliver后无效
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
  const IndexItem({Key? key, required this.index}) : super(key: key);

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

extension SliverConstraintsExtension on SliverConstraints {
  static SliverConstraints empty = const SliverConstraints(
    axisDirection: AxisDirection.down,
    growthDirection: GrowthDirection.forward,
    userScrollDirection: ScrollDirection.forward,
    scrollOffset: 0,
    precedingScrollExtent: 0,
    overlap: 0,
    remainingPaintExtent: 0,
    crossAxisExtent: 0,
    crossAxisDirection: AxisDirection.down,
    viewportMainAxisExtent: 0,
    remainingCacheExtent: 0,
    cacheOrigin: 0,
  );
}

extension SliverGridDelegateWithFixedCrossAxisCountExtension on SliverGridDelegateWithFixedCrossAxisCount {
  double computeMaxScrollOffset({
    int childCount = 0,
    double crossAxisExtent = 0,
    AxisDirection crossAxisDirection = AxisDirection.down,
  }) {
    final constraints = SliverConstraintsExtension.empty.copyWith(
      crossAxisExtent: crossAxisExtent,
      crossAxisDirection: crossAxisDirection,
    );
    return computeMaxScrollOffsetWithConstraints(constraints, childCount: childCount);
  }
}

extension on SliverGridDelegate {
  double computeMaxScrollOffsetWithConstraints(SliverConstraints constraints, {int childCount = 0}) {
    return this.getLayout(constraints).computeMaxScrollOffset(childCount);
  }
}
