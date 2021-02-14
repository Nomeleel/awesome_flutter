import 'package:flutter/material.dart' hide TabBar, Tab, TabBarView;
import 'package:flutter/widgets.dart';

import '../todo/tab_bar.dart';

class TabBarExp extends StatefulWidget {
  TabBarExp({Key key}) : super(key: key);

  @override
  _TabBarExpState createState() => _TabBarExpState();
}

// 竖向的TabBar
// 可以用旋转的方式实现
class _TabBarExpState extends State<TabBarExp> with TickerProviderStateMixin {
  
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 7,
      vsync: this,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 30.0,
            margin: EdgeInsets.only(
              top: 77.77,
              bottom: 10.0,
            ),
            child: TabBar(
              isScrollable: true,
              controller: _controller,
              tabSpacing: 10.0,
              indicator: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              tabDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              tabs: [
                Tab(text: '1'),
                Tab(text: '22'),
                Tab(text: '333'),
                Tab(text: '4444'),
                Tab(text: '55555'),
                Tab(text: '666666'),
                Tab(text: '7777777'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
            controller: _controller,
              children: [
                for (int i = 0; i < _controller.length; i++) 
                  Container(
                    color: Colors.primaries[i % 15],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
