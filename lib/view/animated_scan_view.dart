import 'package:flutter/material.dart';

import '../widget/animated_scan.dart';
import '../widget/scaffold_view.dart';

class AnimatedScanView extends StatelessWidget {
  const AnimatedScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Animated Scan View',
      body: Center(
        child: AnimatedScan(),
      ),
    );
  }
}
