import 'dart:ui';

import 'package:flutter/material.dart';

import '../widget/absorb_stack.dart';
import '../widget/colorful_list_view.dart';
import '../widget/scaffold_view.dart';

class AbsorbStackView extends StatefulWidget {
  const AbsorbStackView({Key key}) : super(key: key);

  @override
  _AbsorbStackViewState createState() => _AbsorbStackViewState();
}

class _AbsorbStackViewState extends State<AbsorbStackView> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
    );

    _children = [
      const ColorfulListView(),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: Colors.white.withOpacity(.2),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Absorb Stack View',
      body: Column(children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.purple,
          ),
          child: TabBar(
            controller: _controller,
            tabs: [
              Tab(text: 'Stack'),
              Tab(text: 'Absorb Stack'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              Stack(
                children: _children,
              ),
              AbsorbStack(
                children: _children,
              )
            ],
          ),
        )
      ]),
    );
  }
}
