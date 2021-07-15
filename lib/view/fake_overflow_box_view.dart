import 'package:flutter/material.dart';

import '../widget/fake_overflow_box.dart';
import '../widget/scaffold_view.dart';

class FakeOverflowBoxView extends StatelessWidget {
  const FakeOverflowBoxView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Fake Overflow Box View',
      body: Column(children: [
        FakeOverflowBox(
          fakeHeight: 120.0,
          child: Container(
            height: 300.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple, Colors.white],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
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
          ),
        )
      ]),
    );
  }
}
