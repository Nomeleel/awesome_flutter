import 'package:flutter/material.dart';

import 'sliver_to_box_adapter.dart';

class ColorfulListView extends StatelessWidget with SliverToBoxAdapterMixin {
  const ColorfulListView({
    Key? key,
    this.itemCount = 77,
    this.itemExtent = 77.77,
    this.itemTextStyle,
    this.controller,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final int itemCount;
  final double itemExtent;
  final TextStyle? itemTextStyle;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  ListView build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) => Container(
        height: itemExtent,
        color: Colors.primaries[index % Colors.primaries.length],
        alignment: Alignment.center,
        child: Text(
          '$index',
          style: itemTextStyle,
        ),
      ),
    );
  }

  @override
  Widget buildSliver(BuildContext context) {
    return boxScrollViewToSliver(context, build(context));
  }
}
