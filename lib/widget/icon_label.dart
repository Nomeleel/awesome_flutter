import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  const IconLabel({
    Key? key,
    this.direction = Axis.horizontal,
    required this.icon,
    this.iconSize = const Size.square(20),
    this.space = 5,
    required this.label,
    this.labelStyle = const TextStyle(color: Colors.black, fontSize: 12),
  }) : super(key: key);

  final Axis direction;

  final String icon;

  final Size iconSize;

  final double space;

  final String label;

  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          icon,
          width: iconSize.width,
          height: iconSize.height,
        ),
        SizedBox.square(dimension: space),
        Text(label, style: labelStyle),
      ],
    );
  }
}
