import 'package:flutter/material.dart';

class FlutterDriverTestView extends StatefulWidget {
  FlutterDriverTestView({Key? key}) : super(key: key);

  @override
  _FlutterDriverTestViewState createState() => _FlutterDriverTestViewState();
}

class _FlutterDriverTestViewState extends State<FlutterDriverTestView> {
  int _listCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Driver Test'),
      ),
      body: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  key: ValueKey('add_count_btn'),
                  onPressed: () => changeListCount(1),
                  child: const Text('Add'),
                ),
                Text(
                  'List Count: $_listCount',
                  key: ValueKey('list_count_text'),
                ),
                ElevatedButton(
                  key: ValueKey('minus_count_btn'),
                  onPressed: _listCount == 0 ? null : () => changeListCount(-1),
                  child: const Text('Minus'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listCount,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  key: ValueKey('list_item_$index'),
                  height: 77.7,
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void changeListCount(int count) {
    setState(() {
      _listCount += count;
    });
  }
}
