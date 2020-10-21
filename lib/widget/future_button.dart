import 'dart:async';

import 'package:flutter/widgets.dart';

class FutureButton2 extends StatelessWidget {
  FutureButton2({Key key, this.child, this.activityIndicator, this.future, this.callBack}) : super(key: key);

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
        await callBack(result);
        _controller.add(true);
      },
      child: child,
    );
  }
}

class FutureButton extends StatefulWidget {
  FutureButton({Key key, this.child, this.activityIndicator, this.future, this.callBack}) : super(key: key);

  final Widget child;

  final Widget activityIndicator;

  final Function future;

  final Function callBack;

  @override
  _XFutureButtonState createState() => _XFutureButtonState();
}

class _XFutureButtonState extends State<FutureButton> {
  bool _isThen = true;

  @override
  Widget build(BuildContext context) {
    return _isThen ? futureButton() : widget.activityIndicator;
  }

  Widget futureButton() {
    return GestureDetector(
      onTap: () async {
        if (!_isThen) {
          return;
        }

        switchWidget();
        var result = await widget.future();
        await widget.callBack(result);
        switchWidget();
      },
      child: widget.child,
    );
  }

  void switchWidget() {
    setState(() {
      _isThen = !_isThen;
    });
  }
}
