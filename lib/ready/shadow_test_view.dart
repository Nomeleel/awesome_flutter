import 'package:flutter/material.dart';

import '../widget/scaffold_view.dart';

class ShadowTestView extends StatelessWidget {
  const ShadowTestView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Material Test View',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PhysicalModel(
              color: Colors.grey,
              elevation: 10.0,
              shadowColor: Colors.red[900],
              clipBehavior: Clip.hardEdge,
              borderRadius: _borderRadius(),
              child: _container(),
            ),
            Card(
              color: Colors.grey,
              elevation: 10.0,
              shadowColor: Colors.red[900],
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: _borderRadius(),
              ),
              child: _container(),
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: _borderRadius(),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.red,
                    offset: Offset(2.0, 8.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: _container(),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  bottomLeft: _borderRadius().bottomLeft
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.red,
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: _container(),
            )
          ],
        ),
      ),
    );
  }

  Widget _container() {
    return ClipRRect(
      borderRadius: _borderRadius(),
      child: Container(
        height: 100.0,
        width: 150.0,
        color: Colors.purple.withOpacity(.7),
      ),
    );
  }

  BorderRadius _borderRadius() => BorderRadius.all(Radius.circular(30.0));
}
