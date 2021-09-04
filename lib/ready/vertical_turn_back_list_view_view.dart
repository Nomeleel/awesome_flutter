import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import '../widget/vertical_turn_back_list_view.dart';
import 'package:flutter/widgets.dart';

class VerticalTurnBackListViewView extends StatelessWidget {
  const VerticalTurnBackListViewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Vertical Turn Back List View Demo',
      body: VerticalTurnBackListView.builder(
        turnBackCount: 7,
        itemCount: 22,
        padding: const EdgeInsets.all(10.0),
        turnBackSeparated: (context, index) => SizedBox(width: 50.0),
        itemBuilder: (context, index) {
          return Container(
            height: 50.0,
            width: 270.0,
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Colors.primaries[index % Colors.primaries.length],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: FittedBox(child: Text('$index')),
          );
        },
      ),
    );
  }
}
