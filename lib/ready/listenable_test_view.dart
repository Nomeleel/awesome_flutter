import 'package:flutter/material.dart';

import '/widget/scaffold_view.dart';

/// abstract class [Listenable]
/// abstract class [ValueListenable]<T> extends [Listenable]
/// class [ValueNotifier]<T> extends [ChangeNotifier] implements [ValueListenable]<T>
/// class [ChangeNotifier] implements [Listenable]
/// abstract class [Animation]<T> extends [Listenable] implements [ValueListenable]<T>
/// class [AnimationController] extends [Animation]<double>
///
/// [ValueListenableBuilder]
/// [AnimatedBuilder]
/// [AlignTransition]
/// [AnimatedAlign]

class ListenableTestView extends StatefulWidget {
  const ListenableTestView({Key? key}) : super(key: key);

  @override
  State<ListenableTestView> createState() => _ListenableTestViewState();
}

class _ListenableTestViewState extends State<ListenableTestView> with SingleTickerProviderStateMixin {
  final duration = Duration(seconds: 2);

  final ValueNotifier<double> valueListenable = ValueNotifier(0);

  late final animationController = AnimationController(duration: duration, vsync: this);

  final alignmentTween = AlignmentTween(begin: Alignment.topLeft, end: Alignment.bottomRight);

  late Alignment alignment = alignmentTween.begin!;

  @override
  void initState() {
    animationController.addListener(() => valueListenable.value = animationController.value);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward)
        setState(() => alignment = alignmentTween.end!);
      else if (status == AnimationStatus.reverse) setState(() => alignment = alignmentTween.begin!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Listenable Test View',
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: valueListenable,
            child: labelBuilder('ValueListenableBuilder + ValueListenable'),
            builder: (BuildContext context, double value, Widget? child) => builder(value, child),
          ),
          ValueListenableBuilder(
            valueListenable: animationController,
            child: labelBuilder('ValueListenableBuilder + AnimationController'),
            builder: (BuildContext context, double value, Widget? child) => builder(value, child),
          ),
          AnimatedBuilder(
            animation: animationController,
            child: labelBuilder('AnimatedBuilder + AnimationController'),
            builder: (BuildContext context, Widget? child) => builder(animationController.value, child),
          ),
          AlignTransition(
            alignment: alignmentTween.animate(animationController),
            child: labelBuilder('AlignTransition + AlignmentTween'),
          ),
          AnimatedAlign(
            alignment: alignment,
            duration: duration,
            child: labelBuilder('AnimatedAlign + Alignment'),
          ),
        ].map((e) => Expanded(child: Container(color: getColor(e.hashCode), child: e))).toList(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: go, child: Text('Go')),
    );
  }

  Widget labelBuilder(String label) {
    return Container(
      height: 30,
      width: 321,
      alignment: Alignment.center,
      decoration: ShapeDecoration(shape: const StadiumBorder(), color: getColor(label.length)),
      child: Text(label),
    );
  }

  Widget builder(double value, Widget? child) => Align(alignment: alignmentTween.transform(value), child: child);

  void go() {
    if (!animationController.isAnimating)
      animationController.isCompleted ? animationController.reverse() : animationController.forward();
  }

  Color getColor(int index) => Colors.primaries[index % Colors.primaries.length];

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }
}
