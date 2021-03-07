import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrollContinuousView extends StatefulWidget {
  const ScrollContinuousView({Key key}) : super(key: key);

  @override
  _ScrollContinuousViewState createState() => _ScrollContinuousViewState();
}

class _ScrollContinuousViewState extends State<ScrollContinuousView> with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          print(notification);
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scroll Continuous View'),
        ),
        body: Column(
          children: [
            Container(
              height: 100.0,
              color: Colors.green,
              child: TabBar(
                controller: _controller,
                tabs: [
                  Tab(text: 'A'),
                  Tab(text: 'B'),
                  Tab(text: 'C'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                physics: ClampingScrollPhysics(),
                children: [
                  PageView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.primaries[index % 15],
                      );
                    },
                  ),
                  ListView.builder(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 100.0,
                        color: Colors.primaries[index % 15],
                      );
                    },
                  ),
                  Container(
                    color: Colors.purple,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
