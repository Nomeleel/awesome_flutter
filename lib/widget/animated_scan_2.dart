import 'package:flutter/material.dart';

class AnimatedScan2 extends StatefulWidget {
  const AnimatedScan2({Key? key}) : super(key: key);

  @override
  State<AnimatedScan2> createState() => _AnimatedScanState2();
}

class _AnimatedScanState2 extends State<AnimatedScan2> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  )..repeat();
  @override
  Widget build(BuildContext context) {
    final colors = [...List.generate(3, (i) => Colors.grey[i * 100 + 100]!.withOpacity(1.0)), Colors.transparent]
        .expand((color) => [color, color])
        .toList();
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
                  stops: [
                    0.0,
                    ...[0.0, 0.3, 0.5].map((e) => e + offset).expand((stop) => [stop, stop]),
                    1.0,
                  ],
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
