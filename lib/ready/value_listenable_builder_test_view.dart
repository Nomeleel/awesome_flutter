import 'package:flutter/material.dart';

class ValueListenableBuilderTestView extends StatelessWidget {
  const ValueListenableBuilderTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> counter = ValueNotifier<int>(0);
    final ValueNotifier<Person> person = ValueNotifier<Person>(Person(id: 7, name: '七', age: counter.value));
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueListenableBuilder Test View'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: person,
              builder: (BuildContext context, Person value, Widget? child) {
                return Column(
                  children: [
                    Text('Id: ${value.id}', style: Theme.of(context).textTheme.headline5),
                    Text('Name: ${value.name}', style: Theme.of(context).textTheme.headline5),
                    Text('Age: ${value.age}', style: Theme.of(context).textTheme.headline4),
                  ],
                );
              },
            ),
            const Text('You have pushed the button this many times:'),
            ValueListenableBuilder(
              valueListenable: counter,
              builder: (BuildContext context, int value, Widget? child) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
          person.value = person.value.copyWith(age: counter.value);
          // 可行
          // final personTemp = person.value..age = counter.value;
          // person.value = null;
          // person.value = personTemp;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Person {
  final int id;
  final String name;

  int age;

  Person({required this.id, required this.name, required this.age});

  Person copyWith({int? age}) {
    return Person(
      id: id,
      name: name,
      age: age ?? this.age,
    );
  }

  // 可以不重写
  // @override
  // operator ==(Object other) {
  //   return other is Person &&
  //       runtimeType == other.runtimeType &&
  //       id == other.id &&
  //       name == other.name &&
  //       age == other.age;
  // }

  // @override
  // int get hashCode => id.hashCode ^ name.hashCode ^ age.hashCode;
}
