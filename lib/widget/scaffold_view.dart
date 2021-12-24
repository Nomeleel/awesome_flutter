import 'package:flutter/material.dart';

// 或者改为继承 如果都是类似简化的操作
class ScaffoldView extends StatelessWidget {
  const ScaffoldView({
    Key? key,
    this.title,
    this.action,
    this.actions,
    this.floatingActionButton,
    required this.body,
  }) : super(key: key);

  final String? title;
  final Widget body;
  final Widget? action;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
        actions: action != null ? [action!] : actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
