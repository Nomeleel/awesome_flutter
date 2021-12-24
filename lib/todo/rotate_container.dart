import 'package:flutter/material.dart';

/// 含有子节点的Widget应用RotatedBox后，子节点要进一步校对调整角度。
/// 就像TabBar改为垂直显示后，每个Tab必须回正旋转水平显示，才能达到TabBar垂直布局的目的。
/// 由于当初将TabBar整体复制到了本地，所以这个效果就直接在本地修改了源码。
/// 如果想对现有Widget直接套用这个效果，就需要这个封装好的Widget了。

// 好像带有Children的Widget都没有什么继承等约束
class RotateContainer extends StatelessWidget with RotatedBoxMixin{
  const RotateContainer({
    Key? key,
    required this.quarterTurns,
    required this.child,
    required this.children,
  }) : super(key: key);

  final int quarterTurns;
  final Widget child;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // 这里还不知道怎么组装children
    // final rotatedChildren = rotateChildren(children, quarterTurns);
    return rotatedBox(child, quarterTurns);
  }
}

mixin RotatedBoxMixin {
  int getReverseQuarterTurns(int quarterTurns) => 4 - (quarterTurns % 4);

  List<Widget> rotateChildren(List<Widget> children, int quarterTurns) {
    final int reverseQuarterTurns = getReverseQuarterTurns(quarterTurns);
    return children.map((e) => rotatedBox(e, reverseQuarterTurns)).toList();
  }

  Widget rotatedBox(Widget child, int quarterTurns) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: child,
    );
  }
}

extension RotatedTabBar on TabBar {

}