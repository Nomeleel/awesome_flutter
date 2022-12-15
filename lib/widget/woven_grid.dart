import 'package:flutter/material.dart';

typedef WovenGridItemBuilder = Widget Function(BuildContext context, Axis axis, int index);

class WovenGrid extends StatelessWidget {
  const WovenGrid({
    Key? key,
    required this.itemExtent,
    required this.mainAxisCount,
    required this.crossAxisCount,
    required this.itemBuilder,
  }) : super(key: key);

  final double itemExtent;
  final int mainAxisCount;
  final int crossAxisCount;
  final WovenGridItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            crossAxisCount,
            (index) => SizedBox(
              width: itemExtent,
              height: mainAxisCount * itemExtent,
              child: itemBuilder(context, Axis.vertical, index),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            mainAxisCount,
            (index) => ClipPath(
              clipper: WovenGridBlockClipper(offset: (index % 2) * itemExtent),
              child: SizedBox(
                width: crossAxisCount * itemExtent,
                height: itemExtent,
                child: itemBuilder(context, Axis.horizontal, index),
              ),
            ),
          ),
        ),
        */
        SizedBox(width: crossAxisCount * itemExtent, height: mainAxisCount * itemExtent),
        for (int index = 0; index < crossAxisCount; index++)
          Positioned(
            top: 0,
            bottom: 0,
            left: index * itemExtent,
            width: itemExtent,
            child: itemBuilder(context, Axis.vertical, index),
          ),
        for (int index = 0; index < mainAxisCount; index++)
          Positioned(
            left: 0,
            right: 0,
            top: index * itemExtent,
            height: itemExtent,
            child: ClipPath(
              clipper: WovenGridBlockClipper(offset: (index % 2) * itemExtent),
              child: itemBuilder(context, Axis.horizontal, index),
            ),
          ),
      ],
    );
  }
}

class WovenGridBlockClipper extends CustomClipper<Path> {
  const WovenGridBlockClipper({this.offset = 0.0});

  final double offset;

  @override
  Path getClip(Size size) {
    final path = Path();
    for (int i = 0; i < (size.width / size.height).ceil(); i += 2) {
      path.addRect(Rect.fromLTWH(i * size.height + offset, 0, size.height, size.height));
    }

    return path;
  }

  @override
  bool shouldReclip(WovenGridBlockClipper oldClipper) => offset != oldClipper.offset;
}
