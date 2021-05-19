import 'package:flutter/material.dart' hide TabBar, Tab, TabBarView;
import 'package:flutter/widgets.dart';

import '../todo/tab_bar.dart';

class TabView extends StatefulWidget {
  const TabView({Key key, @required this.tabs, @required this.children})
      : assert(tabs.length == children.length),
        super(key: key);

  final List<String> tabs;
  final List<Widget> children;

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<Widget> _tabs;
  @override
  void initState() {
    super.initState();

    _tabs = widget.tabs.map((tab) => Tab(text: tab)).toList();

    _controller = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.purple,
          ),
          child: TabBar(
            controller: _controller,
            tabs: _tabs,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
