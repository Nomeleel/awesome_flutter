import 'dart:async';

import 'package:flutter/material.dart' hide Slider;
import 'package:rxdart/rxdart.dart';

import '../widget/slider.dart';
import '../widget/scaffold_view.dart';

class SliderView extends StatefulWidget {
  const SliderView({Key? key}) : super(key: key);

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  final StreamController<int> _streamController = StreamController<int>();
  late StreamSubscription<int> _streamSubscription;
  final slider = ValueNotifier(50);

  @override
  void initState() {
    super.initState();
    _streamSubscription = _streamController.stream
        .throttleTime(const Duration(milliseconds: 100))
        .listen((value) => slider.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Slider View',
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: slider,
              builder: (BuildContext context, int value, Widget? child) => Text('$value'),
            ),
            Slider(value: slider.value, onValueChanged: _streamController.add),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _streamController.close();
    slider.dispose();
    super.dispose();
  }
}
