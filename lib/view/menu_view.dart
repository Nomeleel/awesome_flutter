import 'package:flutter/material.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Menu(),
      ),
    );
  }
}

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: Duration(milliseconds: 300) * active,
    vsync: this,
  )..addListener(() {
      if (mounted) {
        setState(() {
          _offset = controller.value * active * itemHeight - itemHeight / 2;
          _index = (_offset / itemHeight).ceil() - 1;
        });
      }
    });

  final count = 5;
  final active = 5;
  final itemHeight = 50.0;
  final itemWidth = 180.0;

  final color = Colors.amber;
  final activeColor = Colors.pink;
  final borderColor = Colors.black;
  late final borderSide = BorderSide(width: 3, color: borderColor);

  int _index = -1;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              top: -borderSide.width,
              child: DecoratedBox(decoration: _normalDecoration()),
            ),
            if (_index > -1 && _index < count)
              AnimatedPositioned(
                duration: Duration(milliseconds: 77),
                top: itemHeight * _index,
                bottom: itemHeight * (count - _index - 1),
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: activeColor.withOpacity(.5),
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                count,
                (index) => Container(
                  width: itemWidth,
                  height: itemHeight,
                  alignment: Alignment.center,
                  child: Text('$index'),
                ),
              ),
            ),
            Positioned.fill(
              top: _offset,
              bottom: null,
              child: Align(
                alignment: Alignment(-.618, 0),
                child: SizedOverflowBox(
                  size: Size.zero,
                  child: Container(
                    width: 10,
                    height: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: itemWidth,
      height: itemHeight,
      alignment: Alignment.center,
      decoration: _normalDecoration(.7),
      child: Text('标题'),
    );
  }

  BoxDecoration _normalDecoration([double colorOpacity = .5]) {
    return BoxDecoration(
      color: color.withOpacity(colorOpacity),
      border: Border.fromBorderSide(borderSide),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
