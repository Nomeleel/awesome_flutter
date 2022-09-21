import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/scaffold_view.dart';

class PositionedCenterView extends StatelessWidget {
  const PositionedCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = ValueNotifier(77.0);
    Widget listenableContainerBuilder(Color color, [double offset = 0]) {
      return ValueListenableBuilder<double>(
        valueListenable: size,
        builder: (context, value, child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            debugPrint('$color-$offset');
          },
          child: Container(
            width: value + offset,
            height: value + offset,
            color: color,
          ),
        ),
      );
    }

    return ScaffoldView(
      title: 'Positioned Center View',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              for (int i = 1; i <= 8; i++)
                Container(
                  width: 50.0 * i,
                  height: 50.0 * i,
                  color: Colors.primaries[i].withOpacity(.2),
                ),
              // 300 sizedbox
              Positioned(
                top: 200 - 150,
                left: 200 - 150,
                child: Container(
                  width: 300,
                  height: 300,
                  color: Colors.amber.withOpacity(.3),
                  alignment: Alignment.center,
                  child: listenableContainerBuilder(Colors.amber, 20),
                ),
              ),
              // SizedOverflowBox
              Positioned(
                top: 200,
                left: 200,
                child: SizedOverflowBox(
                  size: Size.zero,
                  child: listenableContainerBuilder(Colors.blue.withOpacity(.7), 10),
                ),
              ),
              // OverflowBox
              Positioned(
                top: 200,
                left: 200,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // constraints: BoxConstraints(unconstrained)
                    return SizedBox.shrink(
                      child: OverflowBox(
                        maxWidth: double.infinity,
                        maxHeight: double.infinity,
                        child: listenableContainerBuilder(Colors.purple.withOpacity(.7)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // test SizedOverflowBox
          // purple size < grey szie: 100
          // purple parent size: 0 ~ 100, can tap.
          Container(
            width: 100,
            height: 100,
            color: Colors.grey,
            alignment: Alignment.bottomRight,
            child: SizedOverflowBox(
              size: const Size.square(70),
              child: listenableContainerBuilder(Colors.purple.withOpacity(.7)),
            ),
          ),
          // test OverflowBox
          // purple size < OverflowBox szie: double.infinity
          // purple parent size: 70, 0 ~ 70 can tap.
          Container(
            width: 100,
            height: 100,
            color: Colors.grey,
            alignment: Alignment.bottomRight,
            child: SizedBox.fromSize(
              size: const Size.square(70),
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: listenableContainerBuilder(Colors.blue.withOpacity(.7)),
              ),
            ),
          ),
          ValueListenableBuilder<double>(
            valueListenable: size,
            builder: (context, value, child) => CupertinoSlider(
              min: 10,
              max: 500,
              value: value,
              onChanged: (value) => size.value = value,
            ),
          ),
        ],
      ),
    );
  }
}
