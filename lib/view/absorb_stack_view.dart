import 'dart:ui';

import 'package:flutter/material.dart';

import '../widget/absorb_stack.dart';
import '../widget/colorful_list_view.dart';
import '../widget/scaffold_view.dart';
import '../widget/tab_view.dart';

class AbsorbStackView extends StatefulWidget {
  const AbsorbStackView({Key key}) : super(key: key);

  @override
  _AbsorbStackViewState createState() => _AbsorbStackViewState();
}

class _AbsorbStackViewState extends State<AbsorbStackView> {
  List<Widget> _children;

  @override
  void initState() {
    super.initState();

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
      body: TabView(
        tabs: ['Stack', 'Absorb Stack'],
        children: [
          Stack(children: _children),
          AbsorbStack(children: _children),
        ],
      ),
    );
  }
}
