import 'dart:math';

import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 垂直折回list view
/// 水平折回的可以用grid view代替
class VerticalTurnBackListView extends StatelessWidget {
  const VerticalTurnBackListView.builder({
    Key key,
    @required this.turnBackCount,
    this.padding = EdgeInsets.zero,
    this.turnBackSeparated,
    @required this.itemCount,
    @required this.itemBuilder,
  }) : super(key: key);

  final int turnBackCount;
  final EdgeInsets padding;
  final IndexedWidgetBuilder turnBackSeparated;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      body: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: (itemCount / turnBackCount).ceil(),
        separatorBuilder: (context, index) {
          return turnBackSeparated?.call(context, index) ?? SizedBox.shrink();
        },
        itemBuilder: (context, index) {
          final startIndex = index * turnBackCount;
          final curItemCount = min(itemCount - startIndex, turnBackCount);
          return Column(
            children: List.generate(curItemCount, (i) => itemBuilder(context, startIndex + i)),
          );
        },
      ),
    );
  }
}
