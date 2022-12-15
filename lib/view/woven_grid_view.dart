import 'package:flutter/material.dart';

import '../reference/linked_scroll_controller.dart';
import '../widget/woven_grid.dart';

class WovenGridView extends StatefulWidget {
  const WovenGridView({super.key});

  @override
  State<WovenGridView> createState() => _WovenGridViewState();
}

class _WovenGridViewState extends State<WovenGridView> {
  final LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WovenGrid(
          itemExtent: 150,
          mainAxisCount: 10,
          crossAxisCount: 7,
          itemBuilder: (context, axis, index) {
            final isVertical = axis == Axis.vertical;
            final colorIndex = isVertical ? index : Colors.primaries.length - 1 - index;
            return ColoredBox(
              color: Colors.primaries[colorIndex],
              child: ListView.builder(
                controller: _controllers.addAndGet(),
                scrollDirection: axis,
                reverse: index.isEven,
                itemExtent: 30,
                itemBuilder: (context, i) => Center(
                  child: Container(
                    width: isVertical ? 10 : 20,
                    height: isVertical ? 20 : 10,
                    color: i.isEven ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 
