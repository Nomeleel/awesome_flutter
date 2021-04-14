import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverGridDelegateWithMultipleFixedCrossAxisCount extends SliverGridDelegate {
  const SliverGridDelegateWithMultipleFixedCrossAxisCount({
    @required this.gridDelegateList,
    @required this.mainAxisCountList,
  }) : assert(gridDelegateList.length == mainAxisCountList.length);

  final List<SliverGridDelegateWithFixedCrossAxisCount> gridDelegateList;
  final List<int> mainAxisCountList;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    if (gridDelegateList.length == 1) {
      return getSliverGridLayout(constraints, gridDelegateList.first);
    }
    return SliverGridMultipleTileLayout(
      layoutList: [
        for (var layout in gridDelegateList) getSliverGridLayout(constraints, layout),
      ],
      mainAxisCountList: mainAxisCountList,
    );
  }

  SliverGridLayout getSliverGridLayout(
    SliverConstraints constraints,
    SliverGridDelegateWithFixedCrossAxisCount delegate,
  ) {
    final double usableCrossAxisExtent =
        math.max(0.0, constraints.crossAxisExtent - delegate.crossAxisSpacing * (delegate.crossAxisCount - 1));
    final double childCrossAxisExtent = usableCrossAxisExtent / delegate.crossAxisCount;
    final double childMainAxisExtent = childCrossAxisExtent / delegate.childAspectRatio;
    return SliverGridRegularTileLayout(
      crossAxisCount: delegate.crossAxisCount,
      mainAxisStride: childMainAxisExtent + delegate.mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + delegate.crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithMultipleFixedCrossAxisCount oldDelegate) {
    return oldDelegate.gridDelegateList != gridDelegateList;
  }
}

// ignore: must_be_immutable
class SliverGridMultipleTileLayout extends SliverGridLayout {
  SliverGridMultipleTileLayout({
    @required this.layoutList,
    @required this.mainAxisCountList,
  }) : assert(layoutList.length == mainAxisCountList.length) {
    groupCountList = getGroupCountList();
    scrollOffsetList = getScrollOffsetList();
  }

  final List<SliverGridRegularTileLayout> layoutList;
  final List<int> mainAxisCountList;

  List<int> groupCountList;
  List<double> scrollOffsetList;

  List<int> getGroupCountList() {
    List<int> countList = [0];
    int count = 0;
    for (var i = 0; i < mainAxisCountList.length; i++) {
      countList.add(count += mainAxisCountList[i] * layoutList[i].crossAxisCount);
    }
    return countList;
  }

  List<double> getScrollOffsetList() {
    final List<double> list = [.0];
    double scrollOffset = .0;
    for (var i = 0; i < mainAxisCountList.length; i++) {
      list.add(scrollOffset += (mainAxisCountList[i] * layoutList[i].mainAxisStride));
    }
    return list;
  }

  double _completeGroupOffset(int index) {
    return math.max(0, index ~/ groupCountList.last) * scrollOffsetList.last;
  }

  int _groupIndex(int index) {
    return groupCountList.indexWhere((value) => value > _subIndex(index)) - 1;
  }

  int _subIndex(int index) {
    return index % groupCountList.last;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return layoutList.last.mainAxisStride > 0.0 ? groupCountList.last * (scrollOffset ~/ scrollOffsetList.last) : 0;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int mainAxisCount = (scrollOffset / scrollOffsetList.last).ceil() + 1;
    return math.max(0, (groupCountList.last * mainAxisCount) - 1);
  }

  double _getOffsetFromStartInCrossAxis(SliverGridRegularTileLayout layout, double crossAxisStart) {
    if (layout.reverseCrossAxis)
      return layout.crossAxisCount * layout.crossAxisStride -
          crossAxisStart -
          layout.childCrossAxisExtent -
          (layout.crossAxisStride - layout.childCrossAxisExtent);
    return crossAxisStart;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int groupIndex = _groupIndex(index);
    return subSliverGridGeometry(
      layoutList[groupIndex],
      _completeGroupOffset(index) + scrollOffsetList[groupIndex],
      (index % groupCountList.last) - groupCountList[groupIndex],
    );
  }

  SliverGridGeometry subSliverGridGeometry(SliverGridRegularTileLayout layout, double scrollOffset, int index) {
    final double crossAxisStart = (index % layout.crossAxisCount) * layout.crossAxisStride;
    return SliverGridGeometry(
      scrollOffset: (index ~/ layout.crossAxisCount) * layout.mainAxisStride + scrollOffset,
      crossAxisOffset: _getOffsetFromStartInCrossAxis(layout, crossAxisStart),
      mainAxisExtent: layout.childMainAxisExtent,
      crossAxisExtent: layout.childCrossAxisExtent,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    final int groupIndex = _groupIndex(childCount - 1);
    final double scrollOffset = _completeGroupOffset(childCount - 1) + scrollOffsetList[groupIndex];
    final layout = layoutList[groupIndex];
    final rowCount = ((_subIndex(childCount - 1) - groupCountList[groupIndex] + 1) / layout.crossAxisCount).ceil();
    return scrollOffset + layout.mainAxisStride * rowCount;
  }
}
