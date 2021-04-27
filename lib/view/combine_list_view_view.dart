import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/combine_list_view.dart';
import '../widget/scaffold_view.dart';

class CombineListViewView extends StatelessWidget {
  const CombineListViewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Combine List View View',
      body: CombineListView(
        list: List.generate(22, (e) => e),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 77.77,
            alignment: Alignment.center,
            color: Colors.primaries[index % Colors.primaries.length],
            child: Text('$index'),
          );
        },
        combineList: List.generate(7, (e) => e),
        combineItemBuilder: (BuildContext context, int index) {
          return Container(
            height: 22.22,
            alignment: Alignment.center,
            color: Colors.white,
            child: Text('$index'),
          );
        },
        combineLoopSize: 2,
      ),
    );
  }
}
