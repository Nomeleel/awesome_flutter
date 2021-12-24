import 'package:flutter/material.dart';

import '../widget/colorful_list_view.dart';
import '../widget/scroll_view_jump_top.dart';

class ScrollViewJumpTopView extends StatefulWidget {
  const ScrollViewJumpTopView({Key? key}) : super(key: key);

  @override
  _ScrollViewJumpTopViewState createState() => _ScrollViewJumpTopViewState();
}

class _ScrollViewJumpTopViewState extends State<ScrollViewJumpTopView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll View Jump Top View'),
      ),
      body: ScrollViewJumpTop(
        triggerHeight: 222.222,
        jumpTopBuilder: (BuildContext context) {
          return Container(
            height: 60.0,
            width: 60.0,
            margin: EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Icon(Icons.arrow_upward),
          );
        },
        child: const ColorfulListView(),
      ),
    );
  }
}
