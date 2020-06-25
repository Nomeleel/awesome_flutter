import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../wrapper/cupertino_slider_wrapper.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    Key key,
    this.color,
    this.onColorChanged,
  }) : super(key: key);

  final Color color;

  final ValueChanged<Color> onColorChanged;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> with SingleTickerProviderStateMixin {
  int _groupValue;
  TabController _tabController;

  List<Color> _randomCorlors;
  int _selectedIndex;

  Color _color;

  @override
  void initState() {
    super.initState();

    _groupValue = 0;
    _tabController = TabController(
      length: 2,
      initialIndex: _groupValue,
      vsync: this,
    )..addListener(() {
        setState(() {
          _groupValue = _tabController.index;
        });
      });

    initRandomColor();
  }

  void initRandomColor() {
    _color = _color ?? widget.color ?? const Color(0xff000000);
    _selectedIndex = -1;
    _randomCorlors = List<Color>.generate(
        14, (int index) => Color(Random().nextInt(0xffffffff)));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
        maxHeight: 260,
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(width: 10, height: 10),
          SizedBox(
            width: 200,
            child: CupertinoSegmentedControl<int>(
              groupValue: _groupValue,
              children: const <int, Widget>{
                0: Text('随机'),
                1: Text('自定义'),
              },
              onValueChanged: (int key) {
                _tabController.index = key;
              },
            ),
          ),
          const SizedBox(width: 20, height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                randomPanel(),
                customizePanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget colorCell({int index, bool isNormal = true}) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: index == null ? Colors.transparent : _randomCorlors[index],
          border: Border.all(
            color: index == _selectedIndex ? Colors.red : Colors.white,
            width: 2,
          ),
        ),
        child: isNormal ? null : Icon(Icons.refresh),
      ),
      onTap: () {
        if (isNormal) {
          widget.onColorChanged(_randomCorlors[index]);
          setState(() {
            _selectedIndex = index;
            _color = _randomCorlors[index];
          });
        } else {
          initRandomColor();
          setState(() {});
        }
      },
    );
  }

  Widget randomPanel() {
    return Container(
      child: Wrap(
        children: List<Widget>.generate(
          _randomCorlors.length,
          (int index) => colorCell(index: index),
        )..add(colorCell(isNormal: false)),
      ),
    );
  }

  Widget colorSliderItem(int initValue, Color itemColor, Color Function(int) colorWithItem) {
    return CupertinoSliderWrapper(
      value: initValue.toDouble(),
      min: 0.0,
      max: 255.0,
      activeColor: itemColor,
      onChanged: (double value) {
        _color = colorWithItem(value.toInt());
        widget.onColorChanged(_color);
      },
    );
  }

  Widget customizePanel() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          colorSliderItem(
            _color.red, Colors.red, (int value) => _color.withRed(value)),
          colorSliderItem(
            _color.green, Colors.green, (int value) => _color.withGreen(value)),
          colorSliderItem(
            _color.blue, Colors.blue, (int value) => _color.withBlue(value)),
          colorSliderItem(
            _color.alpha, Colors.white, (int value) => _color.withAlpha(value)),
        ],
      ),
    );
  }
}
