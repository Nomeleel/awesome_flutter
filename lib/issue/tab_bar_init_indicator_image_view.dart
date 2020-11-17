import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabBarInitIndicatorImageView extends StatefulWidget {
  TabBarInitIndicatorImageView({Key key}) : super(key: key);

  @override
  _TabBarInitIndicatorImageViewState createState() => _TabBarInitIndicatorImageViewState();
}

class _TabBarInitIndicatorImageViewState extends State<TabBarInitIndicatorImageView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBar Indicator Image View'),
      ),
      body: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.pink,
            child: TabBar(
              // 只有设置为false此方案才可行(默认为false)
              // 待研究
              isScrollable: false,
              controller: TabController(
                length: 5,
                vsync: this,
              ),
              indicator: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ProgrammingGril.png'),
                  alignment: Alignment.bottomCenter,
                ),
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
          Expanded(
            child: Container(
              // 这里隐藏一个DecorationImage
              height: 0.0,
              width: 0.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ProgrammingGril.png'),
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
