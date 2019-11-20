import 'package:awesome_flutter/waterWaveView.dart';
import 'package:awesome_flutter/yinYangSwitchView.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Map<String, WidgetBuilder> routes = Map<String, WidgetBuilder>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Home"),
      routes: routes,
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

  _MyHomePageState();

  Map<String, WidgetBuilder> routes = MyApp.routes;

  @override
  void initState() {
    // TODO 规范化 根据目录下的文件自动构建路由
    routes["/pages/waterWaveView"] = (BuildContext context) => WaterWaveView();
    routes["/pages/yinYangSwitchView"] = (BuildContext context) => YinYangSwitchView();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(routes.keys.elementAt(index));
            },
            child:  ClipRRect(
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
                        routes.keys.elementAt(index),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
