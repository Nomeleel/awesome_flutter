import 'dart:math';

import 'package:flutter/material.dart';

import '../widget/scaffold_view.dart';

/// 可以通过Flex进行弹性布局
/// 对于弹性布局中的Widget也应当进行缩放
/// Widget的大小数据也会看似失效，只会依赖于父布局大小约束
class FittedBoxTextView extends StatelessWidget {
  const FittedBoxTextView({Key key}) : super(key: key);

  List<Widget> get widgetList => [
    Text('这行字会被进行缩放, 设置字体大小无效', style: TextStyle(fontSize: 1.0)),
    Image.asset('assets/images/RickAndMorty.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Fitted Box Test View',
      body: ListView.builder(
        itemCount: 77,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Container(
      height: Random().nextInt(777) + 77.0,
      alignment: Alignment.center,
      color: Colors.primaries[index % Colors.primaries.length],
      child: ClipRect(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Transform.rotate(
            angle: pi / 4,
            child: FittedBox(
              child: widgetList[Random().nextInt(widgetList.length)],
            ),
          ),
        ),
      ),
    );
  }
}
