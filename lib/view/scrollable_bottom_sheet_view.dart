import 'package:awesome_flutter/widget/colorful_list_view.dart';
import 'package:flutter/material.dart';

import '../widget/scrollable_bottom_sheet.dart';
import '/widget/scaffold_view.dart';

class ScrollableBottomSheetView extends StatefulWidget {
  const ScrollableBottomSheetView({Key? key}) : super(key: key);

  @override
  State<ScrollableBottomSheetView> createState() => _ScrollableBottomSheetViewState();
}

class _ScrollableBottomSheetViewState extends State<ScrollableBottomSheetView> with SingleTickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(duration: const Duration(milliseconds: 270), vsync: this);

  ShapeBorder get _shape => const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20)));

  @override
  Widget build(BuildContext context) {
    final tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
    return ScaffoldView(
      title: 'Scrollable Bottom Sheet View',
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.amber,
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: showBottomSheet,
              child: const Text('Show Scrollable Bottom Sheet'),
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
            child: ScrollableBottomSheet(
              shape: _shape,
              clipBehavior: Clip.hardEdge,
              backgroundColor: Colors.transparent,
              animationController: controller,
              onClosing: onClosing,
              builder: (context, scrollController) => content(750, Colors.purple, scrollController),
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('Show Bottom Sheet'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: _shape,
            clipBehavior: Clip.hardEdge,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.white.withOpacity(.7),
            builder: (context) => content(700, Colors.blue, null),
          );
        },
      ),
    );
  }

  void showBottomSheet() => controller.forward();

  void onClosing() => controller.reverse();

  Widget content(double height, Color color, ScrollController? scrollController) {
    return Container(
      height: height,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(color: color, border: const Border(bottom: BorderSide(color: Colors.cyan))),
          ),
          Expanded(
            child: ColorfulListView(
              padding: const EdgeInsets.all(15),
              controller: scrollController,
            ),
          )
        ],
      ),
    );
  }
}
