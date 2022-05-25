import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RawGestureResearchView extends StatefulWidget {
  const RawGestureResearchView({Key? key}) : super(key: key);

  @override
  State<RawGestureResearchView> createState() => _RawGestureResearchViewState();
}

class _RawGestureResearchViewState extends State<RawGestureResearchView> {
  double offsetX = 0;

  late Map<Type, GestureRecognizerFactory> gestures = <Type, GestureRecognizerFactory>{
    LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
      () => LongPressGestureRecognizer(
        duration: Duration(milliseconds: 500),
        // postAcceptSlopTolerance: 18,
        debugOwner: this,
      ),
      (LongPressGestureRecognizer instance) {
        instance
          ..onLongPressDown = onLongPressDown
          ..onLongPressCancel = onLongPressCancel
          ..onLongPress = onLongPress
          ..onLongPressStart = onLongPressStart
          ..onLongPressMoveUpdate = onLongPressMoveUpdate
          ..onLongPressUp = onLongPressUp
          ..onLongPressEnd = onLongPressEnd;
      },
    ),
  };

  void onLongPressDown(LongPressDownDetails details) {
    print('onLongPressDown: $details');
  }

  void onLongPressCancel() {
    print('onLongPressCancel');
  }

  void onLongPress() {
    print('onLongPress');
  }

  void onLongPressStart(LongPressStartDetails details) {
    print('onLongPressStart: $details');
    offsetX = details.localPosition.dx;
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    print('onLongPressMoveUpdate: $details');

    setState(() {
      alignX += ((details.localPosition.dx - offsetX) / 300);
      alignX = alignX.clamp(0.0, 1.0);
      offsetX = details.localPosition.dx;
      print(alignX);
    });
  }

  void onLongPressUp() {
    print('onLongPressUp');
  }

  void onLongPressEnd(LongPressEndDetails details) {
    print('onLongPressEnd: $details');
  }

  double alignX = 0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      body: Center(
        child: Container(
          width: 350,
          height: 350,
          color: Colors.blue,
          alignment: Alignment(alignX * 2 - 1, 0),
          child: RawGestureDetector(
            gestures: gestures,
            child: Container(
              width: 50,
              height: 10,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}
