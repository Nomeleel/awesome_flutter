import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabBarExp extends StatefulWidget {
  TabBarExp({Key key}) : super(key: key);

  @override
  _TabBarExpState createState() => _TabBarExpState();
}

class _TabBarExpState extends State<TabBarExp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              color: Colors.pink,
              child: TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 200.0,
                ),
                controller: TabController(
                  length: 5,
                  vsync: this,
                ),
                tabs: [
                  Tab(text: '1'),
                  Tab(text: '2'),
                  Tab(text: '3'),
                  Tab(text: '4'),
                  Tab(text: '5'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
