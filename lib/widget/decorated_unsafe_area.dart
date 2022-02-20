import 'package:flutter/material.dart';

class DecoratedUnSafeArea extends StatelessWidget {
  const DecoratedUnSafeArea({Key? key, required this.decoration}) : super(key: key);

  final Decoration decoration;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      child: SafeArea(
        child: Container(
          color: Colors.blue,
        ),
      ),
    );
  }
}
