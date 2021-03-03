import 'package:flutter/material.dart';

class ColorfulListView extends StatelessWidget {
  const ColorfulListView({
    Key key,
    this.itemCount = 77,
    this.itemExtent = 77.77,
    this.itemTextStyle,
  }) : super(key: key);

  final int itemCount;
  final double itemExtent;
  final TextStyle itemTextStyle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) => Container(
        height: itemExtent,
        color: Colors.primaries[index % (Colors.primaries.length - 1)],
        alignment: Alignment.center,
        child: Text(
          '$index',
          style: itemTextStyle,
        ),
      ),
    );
  }
}
