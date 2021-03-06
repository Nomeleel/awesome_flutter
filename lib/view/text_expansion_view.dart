import 'package:flutter/material.dart';

import '../widget/scaffold_view.dart';
import '../widget/text_expansion.dart';

final String text =
    '苏子曰：“客亦知夫水与月乎？逝者如斯，而未尝往也；盈虚者如彼，而卒莫消长也。盖将自其变者而观之，则天地曾不能以一瞬；自其不变者而观之，则物与我皆无尽也，而又何羡乎!且夫天地之间，物各有主,苟非吾之所有，虽一毫而莫取。惟江上之清风，与山间之明月，耳得之而为声，目遇之而成色，取之无禁，用之不竭，是造物者之无尽藏也，而吾与子之所共适。”';

class TextExpansionView extends StatelessWidget {
  const TextExpansionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Text Expansion View',
      body: ListView.builder(
        itemCount: 77,
        itemBuilder: (BuildContext context, int index) => item(index),
      ),
    );
  }

  Widget item(int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.primaries[index % 15],
      ),
      child: TextExpansion(
        text,
        3,
        style: TextStyle(
          fontSize: 24.0,
        ),
        expansionWidget: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.primaries[index % 15],
          ),
          child: Row(
            children: [
              const Text(
                '展开',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 24.0,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.expand_more,
                color: Colors.black54,
                size: 24.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
