import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> count = ValueNotifier<int>(2);
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: count,
        builder: (_, int value, __) {
          return Stack(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: value,
                ),
                itemCount: 777,
                itemBuilder: (_, int index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      key: UniqueKey(),
                      color: Colors.primaries[index % Colors.primaries.length],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0.0,
                height: 200.0,
                left: 0.0,
                right: 0.0,
                child: Slider(
                  min: 1.0,
                  max: 22.0,
                  value: count.value.toDouble(),
                  onChanged: (double value) {
                    count.value = value.toInt();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
