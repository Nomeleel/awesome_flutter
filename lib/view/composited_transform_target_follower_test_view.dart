import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widget/scaffold_view.dart';

class CompositedTransformTargetFollowerTestView extends StatelessWidget {
  const CompositedTransformTargetFollowerTestView({super.key});

  @override
  Widget build(BuildContext context) {
    const height = 30.0, margin = 25.0;
    final link = LayerLink();
    final offset = ValueNotifier(Offset.zero);
    final align = ValueNotifier(0.0)
      ..addListener(
        () {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (link.leader?.offset != null) {
              offset.value = link.leader!.offset;
            }
          });
        },
      );
    return ScaffoldView(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: margin),
                color: Colors.purple,
                child: ValueListenableBuilder<double>(
                  valueListenable: align,
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment(value * 2 - 1, 0),
                          child: CompositedTransformTarget(
                            link: link,
                            child: const ColoredBox(
                              color: Color(0xFF123456),
                              child: SizedBox.square(dimension: height * 2),
                            ),
                          ),
                        ),
                        Slider(value: value, min: 0, max: 1.0, onChanged: (v) => align.value = v),
                      ],
                    );
                  },
                ),
              ),
              ValueListenableBuilder<Offset>(
                valueListenable: offset,
                builder: (context, value, child) {
                  return Text(value.toString());
                },
              ),
            ],
          ),
          CompositedTransformFollower(
            link: link,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.bottomCenter,
            child: Container(
              width: 20,
              height: 20,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
