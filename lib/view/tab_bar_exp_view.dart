import 'package:flutter/material.dart';

import '../widget/scaffold_view.dart';
import '../widget/tabs_exp.dart';

class TabBarExpView extends StatefulWidget {
  const TabBarExpView({Key? key}) : super(key: key);

  @override
  _TabBarExpViewState createState() => _TabBarExpViewState();
}

class _TabBarExpViewState extends State<TabBarExpView> with TickerProviderStateMixin {
  late TabController _controller = TabController(length: 7, vsync: this);
  Axis _direction = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Tab Bar Exp View',
      body: Flex(
        direction: _direction,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: TabBarExp(
              direction: flipAxis(_direction),
              isScrollable: true,
              controller: _controller,
              tabSpacing: 10.0,
              indicator: ShapeDecoration(
                shape: StadiumBorder(),
                gradient: LinearGradient(colors: Colors.primaries.sublist(3, 7)),
              ),
              indicatorWeight: 10,
              tabDecoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: Colors.grey.withOpacity(.2),
              ),
              // indicatorPainter: const UnderlineIndicatorPainter(width: 20, height: 80),
              indicatorPainter: const EarthwormIndicatorPainter(width: 30, height: 7),
              tabs: List.generate(_controller.length, (index) => Tab(text: '${index + 1}' * (index + 1))),
            ),
          ),
          Expanded(
            child: TabBarViewExp(
              scrollDirection: flipAxis(_direction),
              physics: BouncingScrollPhysics(),
              controller: _controller,
              children: List.generate(
                _controller.length,
                (index) => Container(color: Colors.primaries[index % Colors.primaries.length]),
              ),
            ),
          ),
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
