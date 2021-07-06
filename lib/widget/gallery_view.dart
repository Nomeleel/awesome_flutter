import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GalleryView extends StatelessWidget {
  const GalleryView.builder({
    Key key,
    this.minPreRow = 1,
    this.maxPreRow = 77,
    this.duration = const Duration(milliseconds: 300),
    this.itemCount,
    @required this.itemBuilder,
  }) : super(key: key);

  final int minPreRow;
  final int maxPreRow;
  final Duration duration;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> count = ValueNotifier<int>(minPreRow);
    int startCount = minPreRow;
    return Scaffold(
      body: GestureDetector(
        onScaleStart: (e) => startCount = count.value,
        onScaleUpdate: (ScaleUpdateDetails details) {
          count.value = (startCount * (1.0 / details.scale) ~/ 1).clamp(minPreRow, maxPreRow);
        },
        child: ValueListenableBuilder(
          valueListenable: count,
          builder: (_, int value, __) {
            return GridView.builder(
              // TODO: 转变太快, 并且一行不能显示半个然后自动校准
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: value),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return AnimatedSwitcher(
                  duration: duration,
                  child: Container(
                    key: ValueKey('${index ~/ value}-${index % value}'),
                    child: itemBuilder(context, index),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
