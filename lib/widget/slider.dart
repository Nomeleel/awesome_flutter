import 'package:flutter/material.dart';

class Slider extends StatefulWidget {
  const Slider({
    Key? key,
    this.value = 50,
    this.width = 300,
    this.height = 30,
    required this.onValueChanged,
  }) : super(key: key);

  final int value;

  final double width;

  final double height;

  final ValueChanged<int> onValueChanged;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  final ValueNotifier<double> valueNotifier = ValueNotifier(0.0);

  int get value => (valueNotifier.value * _scale * 100).clamp(0, 100).toInt();

  set value(int v) => valueNotifier.value = v / 100 / _scale;

  double get width => widget.width;

  double get height => widget.height;

  double get _scale => width / (width - height);

  @override
  void initState() {
    super.initState();
    valueNotifier.addListener(() => widget.onValueChanged(value));
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant Slider oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Listener(
          onPointerDown: (event) => valueNotifier.value = (event.localPosition.dx - height / 2) / width,
          child: Container(
            height: height,
            width: width,
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              gradient: LinearGradient(colors: Colors.primaries),
            ),
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              heightFactor: 1.0,
              widthFactor: 1 - valueNotifier.value.clamp(0.0, 1.0 - height / width),
              child: Container(
                decoration: ShapeDecoration(shape: StadiumBorder(), color: Theme.of(context).backgroundColor),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) => valueNotifier.value += details.delta.dx / width,
                  child: IgnorePointer(
                    child: Container(
                      width: height,
                      height: height,
                      decoration: ShapeDecoration(shape: CircleBorder(), color: Theme.of(context).indicatorColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }
}
