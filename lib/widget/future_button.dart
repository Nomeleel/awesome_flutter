import 'dart:async';

import 'package:flutter/widgets.dart';

class FutureButton extends StatelessWidget {
  FutureButton({Key key, this.child, this.activityIndicator, this.future, this.callBack}) : super(key: key);

  final Widget child;

  final Widget activityIndicator;

  final Function future;

  final Function callBack;

  final StreamController<bool> _controller = StreamController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _controller.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.active && !snapshot.data) {
          return activityIndicator;
        } else {
          return futureButton();
        }
      },
    );
  }

  Widget futureButton() {
    return GestureDetector(
      onTap: () async {
        _controller.add(false);
        var result = await future();
        callBack(result);
        _controller.add(true);
      },
      child: child,
    );
  }
}
