import 'package:flutter/material.dart';

class AnimatedScan extends StatefulWidget {
  const AnimatedScan({Key? key}) : super(key: key);

  @override
  State<AnimatedScan> createState() => _AnimatedScanState();
}

class _AnimatedScanState extends State<AnimatedScan> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    final colors =
        List.generate(3, (i) => Colors.grey[i * 100 + 100]!.withOpacity(.7)).expand((color) => [color, color]).toList()
          ..removeAt(0)
          ..add(Colors.transparent);
    const ring = 30.0;
    const size = ring * 9;
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < 10; i += 2)
          Container(
            width: size - i * ring,
            height: size - i * ring,
            decoration: ShapeDecoration(
              shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 2)),
              color: Theme.of(context).backgroundColor,
            ),
          ),
        AnimatedBuilder(
          animation: CurveTween(curve: Curves.bounceIn).animate(controller),
          builder: (context, child) {
            final offset = controller.value * 0.5;
            return Container(
              width: size,
              height: size,
              decoration: ShapeDecoration(
                shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 2)),
                gradient: RadialGradient(
                  colors: colors,
                  stops: [0.0, 0.3, 0.5].map((e) => e + offset).expand((stop) => [stop, stop]).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller
      ..stop()
      ..dispose();
    super.dispose();
  }
}
