import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  List _list = <String>[];

  late ValueNotifier<int> _valueListenable = ValueNotifier<int>(_list.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        Container(
          height: 100.0,
          color: Colors.purple,
          child: ValueListenableBuilder(
            valueListenable: _valueListenable,
            builder: (BuildContext context, int length, Widget? child) {
              return Text('$length');
            },
          ),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            //_list = List.generate(_list.length + 1, (index) => '1');
            _list.add('${_list.length}');
            _valueListenable.value = _list.length;
            print(_list);
          },
        ),
      ],
    );
  }
}
