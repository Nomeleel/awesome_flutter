import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_scan/route/view_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: viewRoutes,
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

  @override
  void initState() {

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    List<String> routeNameList = viewRoutes.keys.toList();
    
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: viewRoutes.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(5),
            child: CupertinoButton(
              color: Colors.purple,
              child: Text(routeNameList[index]),
              onPressed: () {
                Navigator.push(context, 
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500), 
                    pageBuilder: (context, animation, secondaryAnimation) {
                      Animation tempAnimation = Tween<double>(
                          begin: 0, 
                          end: 1,
                        ).animate(CurvedAnimation(
                          parent: animation, 
                          curve: Curves.easeInOut,
                        )
                      );

                      return ScaleTransition(
                        scale: tempAnimation,
                        child: viewRoutes[routeNameList[index]](context),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}