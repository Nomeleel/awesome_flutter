import 'package:flutter/material.dart';

typedef MediaQueryWidgetBuilder = Widget Function(MediaQueryData mediaQueryData, Widget? child);

class MediaQueryBuilder extends StatelessWidget {
  const MediaQueryBuilder({Key? key, required this.mediaQueryWidgetBuilder, this.child}) : super(key: key);

  final MediaQueryWidgetBuilder mediaQueryWidgetBuilder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return mediaQueryWidgetBuilder(MediaQuery.of(context), child);
  }
}
