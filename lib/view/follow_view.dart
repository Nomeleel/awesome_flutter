import 'package:flutter/material.dart';

import '../widget/level_follow.dart';
import '../widget/scaffold_view.dart';

class FollowView extends StatelessWidget {
  final int itemCount = 9;

  const FollowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Follow View',
      body: Column(
        children: [
          LevelFollow.builder(
            level: 4,
            itemCount: 10,
            itemBuilder: (_, int index) {
              return Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length],
                  borderRadius: BorderRadius.circular(30.0),
                ),
              );
            },
          ),
          Expanded(
            child: FittedBox(
              child: FlutterLogo(
                size: 100.0,
                style: FlutterLogoStyle.stacked,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
