import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class ListViewScrollToBottomView extends StatefulWidget {
  const ListViewScrollToBottomView({Key? key}) : super(key: key);

  @override
  State<ListViewScrollToBottomView> createState() => _ListViewScrollToBottomViewState();
}

class _ListViewScrollToBottomViewState extends State<ListViewScrollToBottomView> {
  final scrollControllerA = ScrollController();
  final scrollControllerB = ScrollController();

  int _itemCount = 7;

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'List View Scroll To Bottom View',
      action: IconButton(
        icon: const Icon(Icons.arrow_upward),
        onPressed: _scrollToTop,
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollControllerA,
              itemExtent: 100,
              itemCount: _itemCount,
              itemBuilder: (context, index) => _itemBuilder(index),
            ),
          ),
          const VerticalDivider(thickness: 2),
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollControllerB,
              itemExtent: 100,
              itemCount: _itemCount,
              itemBuilder: (context, index) => _itemBuilder(_itemCount - index - 1),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addChild,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemBuilder(int item) {
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.primaries[item % Colors.primaries.length],
      alignment: Alignment.center,
      child: Text('$item'),
    );
  }

  void _addChild() {
    setState(() {
      _itemCount++;
    });

    _scrollToBottomA();
    _scrollToBottomB();
  }

  void _scrollToBottomA() {
    if (scrollControllerA.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollControllerA.animateTo(
          scrollControllerA.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _scrollToBottomB() {
    if (scrollControllerB.hasClients) {
      scrollControllerB.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToTop() {
    if (scrollControllerA.hasClients) {
      scrollControllerA.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    if (scrollControllerB.hasClients) {
      scrollControllerB.animateTo(
        scrollControllerB.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
