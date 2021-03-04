import 'package:flutter/material.dart';

class ScaffoldView extends StatelessWidget {
  const ScaffoldView({
    Key key,
    this.title,
    @required this.body,
  }) : super(key: key);

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: body,
    );
  }
}
