import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../custom/rendering/sliver_grid_delegate.dart';
import '../widget/auto_switch_widget.dart';
import '../widget/scaffold_view.dart';
import '../widget/tab_view.dart';

class CustomGridViewView extends StatelessWidget {
  const CustomGridViewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Custom Grid View View',
      body: TabView(
        tabs: ['Mult Fixed Cross Count', 'Fixed Part Aspect Ratio'],
        children: [
          usedMultipleFixedCrossAxisCount(),
          usedFixedPartAspectRatio(),
        ],
      ),
    );
  }

  Widget usedMultipleFixedCrossAxisCount() {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: 77,
      itemBuilder: (BuildContext context, int index) {
        return AutoSwitchWidget(
          initWidget: 'item',
          widgetMap: {
            'item': Container(
              color: Colors.primaries[index % Colors.primaries.length],
              alignment: Alignment.center,
              child: Text('$index'),
            ),
            'max': Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20.0),
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
    );
  }

  Widget usedFixedPartAspectRatio() {
    final widthNotifier = ValueNotifier(200.0);
    final fixedHeight = 50.0;
    final fixedItem = (index) => Container(
          height: fixedHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.primaries[index % Colors.primaries.length],
            border: Border.all(color: Colors.black),
          ),
          child: Text('A' * 77, style: TextStyle(fontSize: fixedHeight)),
        );
    return Stack(
      children: [
        SingleChildScrollView(child: ListBody(children: List.generate(77, fixedItem))),
        ValueListenableBuilder(
          valueListenable: widthNotifier,
          builder: (_, width, __) {
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: width,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 7,
                      itemBuilder: (_, int index) {
                        return LayoutBuilder(
                          builder: (_, constraints) {
                            return Column(
                              children: [
                                Expanded(child: Container(color: Colors.purple, child: Placeholder())),
                                fixedItem(index),
                              ],
                            );
                          },
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedPartAspectRatio(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        childPartAspectRatio: 1.0,
                        mainAxisPartExtent: fixedHeight,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100.0,
                  child: Slider(
                    value: width,
                    min: 50.0,
                    max: 500.0,
                    onChanged: (value) => widthNotifier.value = value,
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }
}
