import 'package:flutter/material.dart';

import '/widget/scaffold_view.dart';

class BottomSheetTestView extends StatefulWidget {
  const BottomSheetTestView({Key? key}) : super(key: key);

  @override
  State<BottomSheetTestView> createState() => _BottomSheetTestViewState();
}

class _BottomSheetTestViewState extends State<BottomSheetTestView> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(duration: Duration(milliseconds: 270), vsync: this);

  @override
  Widget build(BuildContext context) {
    final tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
    return ScaffoldView(
      title: 'Bottom Sheet Test View',
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: showBottomSheet,
              child: Text('Show Inside'),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (controller.value != 0)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClosing,
                      child: Container(color: Colors.black54),
                    ),
                  FractionalTranslation(
                    translation: tween.transform(controller.value),
                    child: child,
                  ),
                ],
              );
            },
            child: BottomSheet(
              backgroundColor: Colors.transparent,
              animationController: controller,
              onClosing: onClosing,
              builder: (context) => content(550, Colors.purple),
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        child: Text('Show Outside'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.white.withOpacity(.7),
            builder: (context) => content(450, Colors.blue),
          );
        },
      ),
    );
  }

  void showBottomSheet() => controller.forward();

  void onClosing() => controller.reverse();
  
  Widget content(double height, Color color) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
