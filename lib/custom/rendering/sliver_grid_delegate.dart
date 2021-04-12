import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverGridDelegateWithMultipleFixedCrossAxisCount extends SliverGridDelegate {
  const SliverGridDelegateWithMultipleFixedCrossAxisCount({this.gridDelegateList, this.gridRowCountList});

  final List<SliverGridDelegateWithFixedCrossAxisCount> gridDelegateList;
  final List<int> gridRowCountList;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    if (gridDelegateList.length == 1) {
      return getSliverGridLayout(constraints, gridDelegateList.first);
    }
    return SliverGridMultipleTileLayout(
      layoutList: [
        for (var layout in gridDelegateList) getSliverGridLayout(constraints, layout),
      ],
      gridRowCountList: gridRowCountList,
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
    this.layoutList,
    this.gridRowCountList,
  }) : assert(layoutList.length == gridRowCountList.length) {
    groupCountList = getGroupCountList();
    scrollOffsetList = getScrollOffsetList();
  }

  final List<SliverGridRegularTileLayout> layoutList;
  final List<int> gridRowCountList;

  List<int> groupCountList;
  List<double> scrollOffsetList;

  List<int> getGroupCountList() {
    List<int> countList = [0];
    int count = 0;
    for (var i = 0; i < gridRowCountList.length; i++) {
      countList.add(count += gridRowCountList[i] * layoutList[i].crossAxisCount);
    }
    return countList;
  }

  List<double> getScrollOffsetList() {
    final List<double> list = [.0];
    double scrollOffset = .0;
    for (var i = 0; i < gridRowCountList.length; i++) {
      list.add(scrollOffset += (gridRowCountList[i] * layoutList[i].mainAxisStride));
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
