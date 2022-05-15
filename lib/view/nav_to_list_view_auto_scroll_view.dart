import 'dart:math';

import 'package:flutter/material.dart';

class NavToListViewAutoScrollView extends StatelessWidget {
  const NavToListViewAutoScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController(text: '22');
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nav To List View Auto Scroll View'),
        ),
        body: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return ListViewAutoScrollView(
                      index: int.parse(_textEditingController.text),
                    );
                  }));
                },
                child: Text('Go'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewAutoScrollView extends StatefulWidget {
  const ListViewAutoScrollView({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _ListViewAutoScrollViewState createState() => _ListViewAutoScrollViewState();
}

class _ListViewAutoScrollViewState extends State<ListViewAutoScrollView> {
  ScrollController _controller = ScrollController();
  List<GlobalKey> _globalKeyList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      print('-------------------WidgetsBinding-------------------');
      scrollListView();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('-------------------build-------------------');
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      //print('-------------------WidgetsBinding build-------------------');
      //scrollListView();
    });
    return Scaffold(
      body: ListView.builder(
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
    );
  }

  void scrollListView() {
    // print(e.currentContext.findRenderObject().getTransformTo(null).getTranslation().y);
    // 输入验证
    int index = widget.index;
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
      center += _globalKeyList[i].currentContext!.size!.height;
    }
    center += _globalKeyList[index].currentContext!.size!.height / 2;
    print(center);
    return (center - viewportWidth / 2.0).clamp(minExtent, maxExtent);
  }

  double centeredScrollOffset(int index) {
    final ScrollPosition position = _controller.position;
    print('viewportDimension: ${position.viewportDimension}');
    print('minScrollExtent: ${position.minScrollExtent}');
    print('maxScrollExtent: ${position.maxScrollExtent}');
    return targetScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }
}
