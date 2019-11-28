import 'waterWaveView.dart';
import 'yinYangSwitchView.dart';
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
      home: MyHomePage(),
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  _MyHomePageState();

  Map<String, WidgetBuilder> routes = MyApp.routes;

  @override
  void initState() {

    // TODO 规范化 根据目录下的文件自动构建路由
    routes["/pages/yinYangSwitchView"] = (BuildContext context) => YinYangSwitchView();
    routes["/pages/yinYangSwitchView1"] = (BuildContext context) => YinYangSwitchView();
    routes["/pages/yinYangSwitchView2"] = (BuildContext context) => YinYangSwitchView();
    routes["/pages/yinYangSwitchView3"] = (BuildContext context) => YinYangSwitchView();
    routes["/pages/waterWaveView"] = (BuildContext context) => WaterWaveView();

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.purple,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 4,
                right: MediaQuery.of(context).size.width / 4,
              ),
              child: PageView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                controller: PageController(),
                children: <Widget>[
                  for (var i = 0; i < routes.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, 
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 300), 
                            pageBuilder: (context, animation, secondaryAnimation) {
                              Animation tempAnimation = Tween<double>(
                                  begin: 0.5, 
                                  end: 1,
                                ).animate(CurvedAnimation(
                                  parent: animation, 
                                  curve: Curves.easeInOut,
                                )
                              );

                              return ScaleTransition(
                                scale: tempAnimation,
                                child: Function.apply(routes.values.elementAt(i), List()..add(context)),
                              );
                            },
                          ),
                        );
                      },
                      child: Function.apply(routes.values.elementAt(i), List()..add(context)),
                    ),
                ],
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}