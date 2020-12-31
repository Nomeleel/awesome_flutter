import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MyRouteDelegate delegate = MyRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routeInformationParser: MyRouteParser(),
      routerDelegate: delegate,
    );
  }
}

class MyRouteParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class MyRouteDelegate extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final _stack = <String>[];

  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String get currentConfiguration {
    print('currentConfiguration: ${_stack.last}');
    return _stack.isNotEmpty ? _stack.last : '/';
  }

  List<String> get stack => List.unmodifiable(_stack);

  void push(String newRoute) {
    _stack.add(newRoute);
    notifyListeners();
  }

  void pushAndRemoveExist(String newRoute) {
    String mainRouteName = newRoute.split('/').first;
    _stack.removeWhere((e) => e.split('/').first == mainRouteName);
    _stack.add(newRoute);
    notifyListeners();
  }

  bool canPop() {
    return _stack.length > 1;
  }

  void pop() {
    print('----------pop--------------');
    String pageName = _stack.removeLast();
    print(pageName);
    print('---------------------------');
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
    notifyListeners();
  }

  void removeAll() {
    _stack.removeRange(1, _stack.length);
    print('------------_stack------------');
    print(_stack);
    print('---------------------------');
    notifyListeners();
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    print('------setInitialRoutePath: $configuration');
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _stack
      ..clear()
      ..add(configuration);
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    print('-------_onPopPage: ${route.settings.name}-----------------');
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
    }
    return route.didPop(result);
  }

  // Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  //   print('-----_onGenerateRoute: $settings------------');
  //   return MaterialPageRoute(
  //     settings: settings,
  //     builder: (context) => MyHomePage(
  //       title: settings.name,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print('${describeIdentity(this)}.stack: $_stack');
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      //onGenerateRoute: _onGenerateRoute,
      pages: [
        for (final name in _stack)
          MyPage(
            key: ValueKey(name),
            name: name,
          ),
      ],
    );
  }

  // @override
  // Future<bool> popRoute() {
  //   print('-----------popRoute-------------');
  //   final NavigatorState navigator = navigatorKey?.currentState;
  //   if (navigator == null) return SynchronousFuture<bool>(false);
  //   return navigator.maybePop();
  // }
}

class MyPage extends Page {
  const MyPage({
    LocalKey key,
    String name,
  }) : super(
          key: key,
          name: name,
        );

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return name == '/' ? MyHomePage() : MyItemPage(title: name);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go'),
          onPressed: () {
            MyRouteDelegate.of(context).push('Route/1');
          },
        ),
      ),
    );
  }
}

class MyItemPage extends StatefulWidget {
  MyItemPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyItemPageState createState() => _MyItemPageState();
}

class _MyItemPageState extends State<MyItemPage> {
  static int _counter = 1;

  Future<dynamic> _showDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Is this being displayed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('YES'),
            ),
          ],
        );
      },
    );
  }

  void _removeAll() {
    MyRouteDelegate.of(context).removeAll();
  }

  void _incrementCounter() {
    _counter++;
    MyRouteDelegate.of(context).push('Route/$_counter');
    //Navigator.of(context).pushNamed('Route/$_counter');
    // Navigator.of(context).push(MaterialPageRoute(
    //   settings: RouteSettings(name: 'Route/$_counter'),
    //   builder: (context) => MyHomePage(title: 'Route/$_counter',)
    // ));
  }

  void _incrementCounter2() {
    _counter++;
    MyRouteDelegate.of(context).pushAndRemoveExist('Route_Test/$_counter');
  }

  void _back() {
    Navigator.of(context).pop();
    //MyRouteDelegate.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.title.contains('Test') ? Colors.purple : Colors.white,
      appBar: AppBar(
        title: Text('Route: ${widget.title}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              widget.title.split('/')[1],
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'dialog',
            onPressed: () async {
              var dialogResult = await _showDialog();
              print('dialog result: $dialogResult');
            },
            tooltip: 'Show dialog',
            child: Icon(Icons.message),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: _removeAll,
            tooltip: 'Remove All',
            child: Icon(Icons.delete),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            backgroundColor: Colors.cyan,
            heroTag: 'addTest',
            onPressed: _incrementCounter2,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 12.0),
          FloatingActionButton(
            heroTag: 'back',
            backgroundColor: MyRouteDelegate.of(context).canPop() ? null : Colors.grey,
            onPressed: MyRouteDelegate.of(context).canPop() ? _back : null,
            tooltip: 'Increment',
            child: Icon(Icons.arrow_back_ios),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose: ${widget.title}');
  }
}
