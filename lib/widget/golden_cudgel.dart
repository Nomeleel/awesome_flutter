import 'package:flutter/material.dart';

class GoldenCudgel extends StatefulWidget {
  const GoldenCudgel({
    Key? key,
    this.initialWidth: 200,
    this.initialHeight: 100,
    this.stepLength: 77,
  }) : super(key: key);

  final double initialWidth;

  final double initialHeight;

  final double stepLength;

  @override
  State<GoldenCudgel> createState() => _GoldenCudgelState();
}

class _GoldenCudgelState extends State<GoldenCudgel> {
  late double width = widget.initialWidth;
  late double height = widget.initialHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: StadiumBorder(side: BorderSide(color: Colors.yellow)),
        color: Colors.yellowAccent,
      ),
      child: builder(
        center: Expanded(
          child: builder(direction: Axis.vertical, center: Divider(color: Colors.black)),
        ),
      ),
    );
  }

  Widget builder({Axis direction: Axis.horizontal, required Widget center}) {
    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => add(direction),
            child: Icon(Icons.add),
          ),
        ),
        center,
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => minimize(direction),
            child: Icon(Icons.minimize),
          ),
        ),
      ],
    );
  }

  void add(Axis direction) => _change(direction, widget.stepLength);

  void minimize(Axis direction) => _change(direction, -widget.stepLength);

  void _change(Axis direction, double length) {
    if (direction == Axis.horizontal) {
      if (_canChange(width, length)) setState(() => width += length);
    } else {
      if (_canChange(height, length)) setState(() => height += length);
    }
  }

  bool _canChange(double size, double change) => change >= 0 || size + change > 0;
}
