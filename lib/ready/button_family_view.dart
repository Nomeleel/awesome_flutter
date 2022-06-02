import 'package:flutter/material.dart';

import '/widget/scaffold_view.dart';
import '/widget/tab_view.dart';

class ButtonFamilyView extends StatefulWidget {
  const ButtonFamilyView({Key? key}) : super(key: key);

  @override
  State<ButtonFamilyView> createState() => _ButtonFamilyViewState();
}

class _ButtonFamilyViewState extends State<ButtonFamilyView> {
  final int itemCount = 7;

  final double buttomHeight = 25;

  final BorderRadius borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      body: TabView(
        tabs: const ['Popup Menu', 'Drop down'],
        children: [
          _buildPopupMenuButtonView(),
          _buildDropdownButtonView(),
        ],
      ),
    );
  }

  Widget _buildPopupMenuButtonView() {
    return _withAlign(
      PopupMenuButton(
        // initialValue: 2,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return List.generate(itemCount, (index) => PopupMenuItem(value: index, child: Center(child: Text('$index'))));
        },
        child: _buildButton(Text('Popup Menu Button')),
      ),
    );
  }

  Widget _buildDropdownButtonView() {
    return _withAlign(
      DropdownButton(
        // value: 2,
        hint: Text('请选择'),
        borderRadius: borderRadius,
        alignment: Alignment.topLeft,
        items: List.generate(7, (index) => DropdownMenuItem(value: index, child: Center(child: Text('$index')))),
        onChanged: print,
      ),
    );
  }

  Widget _withAlign(Widget child) => Align(alignment: const Alignment(0, -.5), child: child);

  Widget _buildButton(Widget child, {double height = 30, double width = 200}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.cyan,
        border: Border.all(color: Colors.blue),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
