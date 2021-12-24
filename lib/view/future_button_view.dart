import 'package:awesome_flutter/widget/future_button.dart';
import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FutureButtonView extends StatefulWidget {
  const FutureButtonView({Key? key}) : super(key: key);

  @override
  _FutureButtonViewState createState() => _FutureButtonViewState();
}

class _FutureButtonViewState extends State<FutureButtonView> {
  Widget get child => container(const Text('Go'));
  Widget get activityIndicator => container(const CupertinoActivityIndicator(), true);

  Widget container(Widget child, [bool isDisable = false]) => Container(
        height: 50.0,
        width: 120.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisable ? Colors.grey : Colors.purple,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: child,
      );

  Future<void> future() {
    return Future.delayed(Duration(seconds: 3));
  }

  void callback([dynamic value]) {
    print('Finish...');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Future Button View',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 100.0),
            Text('Use setState'),
            FutureButton(
              future: future,
              callBack: callback,
              child: child,
              activityIndicator: activityIndicator,
            ),
            Text('Use StreamController'),
            FutureButton2(
              future: future,
              callBack: callback,
              child: child,
              activityIndicator: activityIndicator,
            ),
            Text('Use ValueNotifier'),
            FutureButton3(
              future: future,
              callBack: callback,
              child: child,
              activityIndicator: activityIndicator,
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
