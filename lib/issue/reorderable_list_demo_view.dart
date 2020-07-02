import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReorderableListDemoView extends StatefulWidget {
  @override
  _ReorderableListDemoViewState createState() => _ReorderableListDemoViewState();
}

class _ReorderableListDemoViewState extends State<ReorderableListDemoView> {

  List<Widget> _widgetList;

  defText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
    );
  }

  @override
  void initState() {
    
    _widgetList = List.generate(7, (index) => 
      Container(
        key: ValueKey('$index'),
        height: 55,
        color: Color(Random().nextInt(0xFFFFFFFF)),
        alignment: Alignment.center,
        child: defText('$index'),
      )
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.center,
              child: defText('Can try to drag.'),
            ),
            Expanded(
              child: ReorderableListView(
                  children: _widgetList,
                  onReorder: onReorder,
                ),
            ),
          ],
        ),
      ),
    );
  }

  onReorder(int oldIndex, int newIndex) {
    print('oldIndex: $oldIndex newIndex: $newIndex');
    // When the item is dragged from the up to down, the new index is always increased by one. 
    // According to my understanding, this should be a issue. Here, special logic is used to deal with this issue. 
    // I will create this issue on flutter.
    if (newIndex > oldIndex)
      newIndex--;

    int direction = oldIndex < newIndex ? 1 : -1;

    var temp = _widgetList[oldIndex];
    var check = (index) => (newIndex - index).abs() + (oldIndex - index).abs() == (newIndex - oldIndex).abs(); 
    for (int i = oldIndex; check(i); i += direction) {
      _widgetList[i] = _widgetList[i + direction];
    }
    _widgetList[newIndex] = temp; 
  }

}
