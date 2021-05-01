import 'package:flutter/material.dart';

// 或者改为继承 如果都是类似简化的操作
class ScaffoldView extends StatelessWidget {
  const ScaffoldView({
    Key key,
    this.title,
    this.floatingActionButton,
    @required this.body,
  }) : super(key: key);

  final String title;
  final Widget body;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: body,
      floatingActionButton: floatingActionButton
    );
  }
}
