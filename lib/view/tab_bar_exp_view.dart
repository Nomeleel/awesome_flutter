import 'package:flutter/material.dart' hide TabBar, Tab, TabBarView;
import 'package:flutter/widgets.dart';

import '../todo/tab_bar.dart';
import '../widget/scaffold_view.dart';

class TabBarExpView extends StatefulWidget {
  const TabBarExpView({Key key}) : super(key: key);

  @override
  _TabBarExpViewState createState() => _TabBarExpViewState();
}

class _TabBarExpViewState extends State<TabBarExpView> with TickerProviderStateMixin {
  TabController _controller;
  Axis _direction = Axis.vertical;

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
    return ScaffoldView(
      title: 'Tab Bar Exp View',
      body: Flex(
        direction: _direction,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //height: 30.0,
            margin: EdgeInsets.all(7.7),
            child: TabBar(
              direction: flipAxis(_direction),
              isScrollable: true,
              controller: _controller,
              tabSpacing: 10.0,
              indicator: BoxDecoration(
                color: Colors.purple.withOpacity(.7),
                borderRadius: BorderRadius.circular(15.0),
              ),
              tabDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(15.0),
              ),
              tabs: [
                for (int i = 1; i <= _controller.length; i++)
                  Tab(
                    text: List.filled(i, i).join(),
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              scrollDirection: flipAxis(_direction),
              physics: BouncingScrollPhysics(),
              controller: _controller,
              children: [
                for (int i = 0; i < _controller.length; i++)
                  Container(
                    color: Colors.primaries[i % Colors.primaries.length],
                  )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _direction = flipAxis(_direction);
          });
        },
        child: Icon(Icons.rotate_left),
      ),
    );
  }
}
