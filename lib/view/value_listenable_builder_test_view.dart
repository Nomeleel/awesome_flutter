import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ValueListenableBuilderTestView extends StatefulWidget {
  ValueListenableBuilderTestView({Key key}) : super(key: key);

  @override
  _ValueListenableBuilderTestViewState createState() => _ValueListenableBuilderTestViewState();
}

class _ValueListenableBuilderTestViewState extends State<ValueListenableBuilderTestView> {
  ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _incrementCounter() {
    _counter.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueListenableBuilder Test View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ValueListenableBuilder(
              valueListenable: _counter,
              builder: (BuildContext context, int value, Widget child) {
                return Text(
                  '${_counter.value}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _counter,
              builder: (BuildContext context, int value, Widget child) {
                return Text(
                  '${_counter.value}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _counter,
              builder: (BuildContext context, int value, Widget child) {
                return Text(
                  '${_counter.value}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
