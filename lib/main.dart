import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Home"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List pages;

  @override
  void initState() {
    pages = List();
    pages.add("1");
    pages.add("2");
    pages.add("3");
    pages.add("4");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.618 + 50,
              color: Colors.deepOrange,
              child: Column(
                children: <Widget>[
                  Container(
                    height: (MediaQuery.of(context).size.width - 30) * 0.618 - 30,
                    color: Colors.green,
                  ),
                  Container(
                    height: 33,
                    color: Colors.purple,
                  ),
                  Container(
                    height: 33,
                    color: Colors.blue,
                    child: Text(
                      pages[index] * 30,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
