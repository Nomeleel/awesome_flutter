import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListViewAutoScrollView extends StatefulWidget {
  ListViewAutoScrollView({Key key}) : super(key: key);

  @override
  _ListViewAutoScrollViewState createState() => _ListViewAutoScrollViewState();
}

class _ListViewAutoScrollViewState extends State<ListViewAutoScrollView> {
  TextEditingController _textEditingController;
  ScrollController _controller;
  List<GlobalKey> _globalKeyList;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _controller = ScrollController();
    _globalKeyList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List View Auto Scroll View'),
      ),
      body: Column(
        children: [
          Container(
            height: 100.0,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: scrollListView,
                    child: Text('Go'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              cacheExtent: double.maxFinite,
              padding: EdgeInsets.zero,
              itemCount: 77,
              itemBuilder: (BuildContext context, int index) {
                GlobalKey globalKey = GlobalKey();
                _globalKeyList.add(globalKey);
                return Container(
                  key: globalKey,
                  height: Random().nextInt(200).toDouble(),
                  //height: 50.0,
                  color: Colors.primaries[index % 15],
                  alignment: Alignment.center,
                  child: Text('$index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void scrollListView() {
    // print(e.currentContext.findRenderObject().getTransformTo(null).getTranslation().y);
    // 输入验证
    int index = int.parse(_textEditingController.text);
    print(index);
    // _globalKeyList.forEach((e) {
    //   print(e.currentContext.size.height);
    // });

    _controller.jumpTo(centeredScrollOffset(index));
  }

  // 当前仅考虑纵向listview
  double targetScrollOffset(int index, double viewportWidth, double minExtent, double maxExtent) {
    //if (isScrollable) return 0.0;
    double center = 0.0;
    for (int i = 0; i < index; i++) {
      center += _globalKeyList[i].currentContext.size.height;
    }
    center += _globalKeyList[index].currentContext.size.height / 2;
    print(center);
    //return (center - viewportWidth / 2.0).clamp(minExtent, maxExtent) as double;
    return center - viewportWidth / 2.0;
  }

  double centeredScrollOffset(int index) {
    final ScrollPosition position = _controller.position;
    print('viewportDimension: ${position.viewportDimension}');
    print('minScrollExtent: ${position.minScrollExtent}');
    print('maxScrollExtent: ${position.maxScrollExtent}');
    return targetScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }
}
