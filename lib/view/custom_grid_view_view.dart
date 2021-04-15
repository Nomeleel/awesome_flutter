import 'dart:ui';

import 'package:flutter/material.dart';

import '../custom/rendering/sliver_grid_delegate.dart';
import '../widget/auto_switch_widget.dart';
import '../widget/scaffold_view.dart';

class CustomGridViewView extends StatelessWidget {
  const CustomGridViewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Custom Grid View View',
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: 77,
        itemBuilder: (BuildContext context, int index) {
          return AutoSwitchWidget(
            initWidget: 'item',
            widgetMap: {
              'item': Container(
                color: Colors.primaries[index % (Colors.primaries.length - 1)],
                alignment: Alignment.center,
                child: Text('$index'),
              ),
              'max': Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Text(
                  '$index',
                  style: TextStyle(fontSize: 77.0),
                ),
              ),
            },
            widgetSwitch: (Size size) => size.width > size.height ? 'max' : 'item',
          );
        },
        gridDelegate: SliverGridDelegateWithMultipleFixedCrossAxisCount(
          gridDelegateList: [
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 3,
            ),
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: .9,
            ),
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.2,
            ),
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
          ],
          mainAxisCountList: [1, 1, 2, 3],
        ),
      ),
    );
  }
}
