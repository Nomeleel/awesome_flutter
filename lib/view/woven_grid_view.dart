import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class WovenGridView extends StatefulWidget {
  const WovenGridView({Key? key}) : super(key: key);

  @override
  State<WovenGridView> createState() => _WovenGridViewState();
}

class _WovenGridViewState extends State<WovenGridView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      body: Center(
        child: WovenGrid(
          itemExtent: 150,
          mainAxisCount: 10,
          crossAxisCount: 10,
          itemBuilder: (context, mainAxisIndex, crossAxisIndex) => ColoredBox(
            color: Colors.primaries[(mainAxisIndex + crossAxisIndex) % Colors.primaries.length],
          ),
        ),
      ),
    );
  }
}

typedef Widget WovenGridItemBuilder(BuildContext context, int mainAxisIndex, int crossAxisIndex);

class WovenGrid extends StatelessWidget {
  const WovenGrid({
    super.key,
    required this.itemExtent,
    required this.mainAxisCount,
    required this.crossAxisCount,
    required this.itemBuilder,
  });

  final double itemExtent;
  final int mainAxisCount;
  final int crossAxisCount;
  final WovenGridItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final size = Size(crossAxisCount * itemExtent, mainAxisCount * itemExtent);
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            crossAxisCount,
            (index) => Container(width: itemExtent, height: size.height, color: Colors.primaries[index]),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            mainAxisCount,
            (index) => ClipPath(
              clipper: WovenGridBlockClipper(offset: (index % 2) * itemExtent),
              child: Container(
                  width: size.width, height: itemExtent, color: Colors.primaries[Colors.primaries.length - 1 - index]),
            ),
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
    print(size);
    final path = Path();
    for (int i = 0; i < (size.width / size.height).ceil(); i += 2)
      path.addRect(Rect.fromLTWH(i * size.height + offset, 0, size.height, size.height));

    return path;
  }

  @override
  bool shouldReclip(WovenGridBlockClipper oldClipper) => offset != oldClipper.offset;
}

/*

for (int index = 0; index < crossAxisCount; index++)
  Positioned(
    top: 0,
    bottom: 0,
    left: index * itemExtent,
    width: itemExtent,
    child: ColoredBox(color: Colors.primaries[index].withOpacity(.6)),
  ),
// for (int index = 0; index < mainAxisCount; index++)
//   Positioned.fill(
//     top: index * itemExtent,
//     bottom: (mainAxisCount - index - 1) * itemExtent,
//     child: ClipPath(
//       clipper: WovenGridBlockClipper(offset: (index % 2) * itemExtent),
//       child: ColoredBox(color: Colors.primaries[Colors.primaries.length - 1 - index]),
//     ),
//   ),

*/