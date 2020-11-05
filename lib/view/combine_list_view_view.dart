import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CombineListView extends StatefulWidget {
  CombineListView({Key key}) : super(key: key);

  @override
  _CombineListViewState createState() => _CombineListViewState();
}

class _CombineListViewState extends State<CombineListView> {
  ScrollController _controller;
  List<Widget> _list;
  List _combineList;
  int _combineLoopSize = 1;
  bool _isCombine = true;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller
      ..removeListener(listener)
      ..addListener(listener);

    _list = <Widget>[];
    loadMore();

    // init combine info
    if (_isCombine) {
      // get combine list
      _combineList = ['A', 'B', 'C'];
      // valid combine loop size
      if (_combineLoopSize == null || _combineLoopSize == 0) {
        _combineLoopSize = 2 ^ 63 - 1;
      }
    }
  }

  void listener() {
    if (_controller.offset == _controller.position.maxScrollExtent) {
      setState(() {
        loadMore();
      });
    }
  }

  void loadMore() {
    _list.addAll(List.generate(22, (index) => listItem()));
  }

  Widget listItem() {
    return Container(
      height: 77.0,
      color: Color(Random().nextInt(0xFFFFFFFF)),
    );
  }

  Widget combineItem(String tag) {
    return Container(
      height: 77.0,
      color: Colors.purple,
      alignment: Alignment.center,
      child: Text(tag),
    );
  }

  Widget combine(int index, {Widget listItem}) {
    Widget combine = listItem ?? _list[index];

    if (_combineList != null && _combineList.isNotEmpty && (index + 1) % _combineLoopSize == 0) {
      int combineIndex = (index ~/ _combineLoopSize) % _combineList.length;
      combine = Column(
        children: [
          _list[index],
          combineItem(_combineList[combineIndex]),
        ],
      );
    }

    return combine;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combine List View'),
      ),
      body: ListView.builder(
        controller: _controller,
        physics: ClampingScrollPhysics(),
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) => combine(index),
      ),
    );
  }
}
