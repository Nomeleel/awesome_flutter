import 'package:flutter/material.dart';

import '../widget/scaffold_view.dart';
import '../widget/tabs_exp.dart';

class TabBarViewExpView extends StatefulWidget {
  const TabBarViewExpView({Key? key}) : super(key: key);

  @override
  _TabBarViewExpViewState createState() => _TabBarViewExpViewState();
}

class _TabBarViewExpViewState extends State<TabBarViewExpView> with TickerProviderStateMixin {
  late TabController _controller = TabController(length: 7, vsync: this);

  double viewportFraction = .7;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = Offset((viewportFraction - 1) * screenWidth / 2, 0);

    final tabBarView = TabBarViewExp(
      key: UniqueKey(),
      physics: BouncingScrollPhysics(),
      controller: _controller,
      viewportFraction: viewportFraction,
      children: List.generate(
        _controller.length,
        (index) => Transform.translate(offset: offset, child: TabViewItem(index: index)),
      ),
    );

    return ScaffoldView(
      title: 'Tab Bar View Exp View',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: TabBarExp(
              isScrollable: true,
              controller: _controller,
              tabSpacing: 7.0,
              labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              indicator: ShapeDecoration(
                shape: StadiumBorder(),
                gradient: LinearGradient(colors: Colors.primaries.sublist(3, 7)),
              ),
              indicatorPainter: const EarthwormIndicatorPainter(width: 30, height: 7),
              tabs: List.generate(_controller.length, (index) => Tab(text: '${index + 1}' * (index + 1))),
            ),
          ),
          Expanded(child: tabBarView),
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Slider(
              value: viewportFraction,
              min: .2,
              max: 1.5,
              onChanged: (value) {
                setState(() {
                  viewportFraction = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabViewItem extends StatefulWidget {
  const TabViewItem({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<TabViewItem> createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.primaries[widget.index % Colors.primaries.length],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${widget.index + 1}',
        style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
      ),
    );
  }
}
