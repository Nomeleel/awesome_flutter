import 'dart:math';

import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListViewAutoScrollViewView extends StatefulWidget {
  const ListViewAutoScrollViewView({Key key}) : super(key: key);

  @override
  _ListViewAutoScrollViewViewState createState() => _ListViewAutoScrollViewViewState();
}

class _ListViewAutoScrollViewViewState extends State<ListViewAutoScrollViewView> {
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
    return ScaffoldView(
      title: 'List View Auto Scroll View View',
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
                  color: Colors.primaries[index % Colors.primaries.length],
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
    return (center - viewportWidth / 2.0).clamp(minExtent, maxExtent) as double;
  }

  double centeredScrollOffset(int index) {
    final ScrollPosition position = _controller.position;
    print('viewportDimension: ${position.viewportDimension}');
    print('minScrollExtent: ${position.minScrollExtent}');
    print('maxScrollExtent: ${position.maxScrollExtent}');
    return targetScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }
}
