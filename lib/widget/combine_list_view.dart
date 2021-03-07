import 'package:flutter/widgets.dart';

class CombineListView extends StatefulWidget {
  const CombineListView({
    Key key,
    @required this.list,
    @required this.combineList,
    this.combineLoopSize = 1,
    @required this.itemBuilder,
    @required this.combineItemBuilder,
  }) : super(key: key);

  final List list;
  final List combineList;

  final int combineLoopSize;

  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder combineItemBuilder;

  @override
  _CombineListViewState createState() => _CombineListViewState();
}

class _CombineListViewState extends State<CombineListView> {
  ScrollController _controller;
  List _list;

  bool get isCombine => (widget.combineList?.isNotEmpty ?? false) && widget.combineItemBuilder != null;

  @override
  void initState() {
    super.initState();
    _list = []..addAll(widget.list);

    _controller = ScrollController();
    _controller
      ..removeListener(listener)
      ..addListener(listener);
  }

  void listener() {
    if (_controller.offset == _controller.position.maxScrollExtent) {
      setState(() {
        loadMore();
      });
    }
  }

  void loadMore() {
    _list.addAll(widget.list);
  }

  List<Widget> childrenCombine(BuildContext context) {
    List<Widget> children = [];
    final int combineLoopSize = widget.combineLoopSize;
    List.generate(_list.length, (int index) {
      children.add(widget.itemBuilder(context, index));
      if (isCombine && (index + 1) % combineLoopSize == 0) {
        int combineIndex = (index ~/ combineLoopSize) % widget.combineList.length;
        children.add(widget.combineItemBuilder(context, combineIndex));
      }
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final List children = childrenCombine(context);
    return ListView.builder(
      controller: _controller,
      physics: ClampingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (BuildContext context, int index) => children[index],
    );
  }
}
