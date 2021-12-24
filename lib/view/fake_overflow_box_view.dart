import '../widget/tab_view.dart';
import 'package:flutter/material.dart';

import '../widget/fake_overflow_box.dart';
import '../widget/scaffold_view.dart';

class FakeOverflowBoxView extends StatelessWidget {
  const FakeOverflowBoxView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Fake Overflow Box View',
      body: TabView(
        tabs: [
          'Box View',
          'Sliver View',
        ],
        children: [
          boxView(),
          sliverView(context),
        ],
      ),
    );
  }

  Widget boxView() {
    return Column(
      children: [
        _fakeOverflowBox(),
        Expanded(child: _listView()),
      ],
    );
  }

  Widget sliverView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFakeOverflow(child: _container()),
        // SliverToBoxAdapter(child: _fakeOverflowBox()),
        _listView().buildChildLayout(context),
      ],
    );
  }

  FakeOverflowBox _fakeOverflowBox() {
    return FakeOverflowBox(fakeHeight: 120.0, child: _container());
  }

  Container _container() {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple, Colors.white],
        ),
      ),
    );
  }

  ListView _listView() {
    return ListView.separated(
      itemCount: 77,
      itemBuilder: (_, int index) => Container(
        height: 77.0,
        color: Colors.transparent,
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),
        ),
      ),
      separatorBuilder: (_, __) => Divider(height: 5.0, color: Colors.black),
    );
  }
}