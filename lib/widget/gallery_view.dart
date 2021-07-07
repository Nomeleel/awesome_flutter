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
    final ValueNotifier<double> scale = ValueNotifier<double>(1.0);
    int startCount = minPreRow;
    double startScale = 1.0;
    return Scaffold(
      body: GestureDetector(
        onScaleStart: (e) {
          startCount = count.value;
          startScale = scale.value;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          count.value = (startCount * (1.0 / details.scale) ~/ 1).clamp(minPreRow, maxPreRow);
          scale.value = startScale * details.scale;
        },
        child: ValueListenableBuilder(
          valueListenable: scale,
          builder: (_, double value, __) {
            return Transform.scale(
              scale: value,
              alignment: Alignment.topLeft,
              child: GridView.builder(
                // TODO: 转变太快, 并且一行不能显示半个然后自动校准
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: count.value),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
