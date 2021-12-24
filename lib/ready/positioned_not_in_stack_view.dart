import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widget/scaffold_view.dart';

class PositionedNotInStackView extends StatelessWidget {
  const PositionedNotInStackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Positioned Not In Stack View',
      body: Column(
        children: [
          PositionedWrap(
            child: _container(),
          ),
          Stack(
            children: [
              PositionedWrap(
                child: _container(),
              ),
              FlutterLogo(size: 200.0),
              Stack(
                children: [
                  PositionedWrap(
                    child: _container(),
                  ),
                  FlutterLogo(size: 220.0),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _container() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.purple,
    );
  }
}

class PositionedWrap extends StatelessWidget {
  const PositionedWrap({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    bool isInStack = false;
    context.visitAncestorElements((element) {
      isInStack = element.renderObject.runtimeType == RenderStack;
      return false;
    });
    // final isInStack = context.findAncestorWidgetOfExactType<Stack>().children.any((e) => e == this);
    if (isInStack) {
      return Positioned(
        top: 20.0,
        left: 20.0,
        child: child,
      );
    }
    return child;
  }
}
