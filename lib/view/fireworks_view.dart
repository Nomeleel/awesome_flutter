import 'package:flutter/material.dart';

import '../custom/painter/fireworks_painter.dart';

class FireworksView extends StatefulWidget {
  const FireworksView({Key? key}) : super(key: key);

  @override
  _FireworksViewState createState() => _FireworksViewState();
}

class _FireworksViewState extends State<FireworksView> with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    duration: const Duration(hours: 1),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        size: Size.infinite,
        painter: FireworksPainter(animationController),
      ),
    );
  }

  @override
  void dispose() {
    animationController
      ..stop()
      ..dispose();
    super.dispose();
  }
}
