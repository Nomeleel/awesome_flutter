// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MyRouteDelegate delegate = MyRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Navigator 2.0 Demo',
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
    return SynchronousFuture(routeInformation.location!);
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final _pages = <String>[];

  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  static MyRouteDelegate? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_RouteDelegateInherited>()?.routeDelegate;
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String get currentConfiguration {
    print('currentConfiguration: ${_pages.last}');
    return _pages.isNotEmpty ? _pages.last : '/';
  }

  List<String> get pages => List.unmodifiable(_pages);

  void push(String newRoute) {
    _pages.add(newRoute);
    notifyListeners();
  }

  void pushAndRemoveExist(String newRoute) {
    String mainRouteName = newRoute.split('/').first;
    _pages.removeWhere((e) => e.split('/').first == mainRouteName);
    _pages.add(newRoute);
    notifyListeners();
  }

  bool canPop() {
    return _pages.length > 1;
  }

  void pop() {
    print('----------pop--------------');
    String pageName = _pages.removeLast();
    print(pageName);
    print('---------------------------');
    notifyListeners();
  }

  void remove(String routeName) {
    print('----------remove: $routeName--------------');
    print(pages);
    print('------------------------------------------');
    _pages.remove(routeName);
    notifyListeners();
  }

  void removeAll() {
    _pages.removeRange(1, _pages.length);
    print('------------_stack------------');
    print(_pages);
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
    print('------setNewRoutePath: $configuration');
    _pages.add(configuration);
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    print('-------_onPopPage: ${route.settings.name}-----------------');
    if (canPop()) {
      _pages.removeLast();
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
    print('${describeIdentity(this)}.pages: $_pages');
    return _RouteDelegateInherited(
      routeDelegate: this,
      child: Navigator(
        key: navigatorKey,
        onPopPage: _onPopPage,
        onGenerateRoute: _onGenerateRoute,
        pages: _pages.map(_buildPage).toList(),
      ),
    );
  }

  // TODO: Not fully supported.
  Route<dynamic>? _onGenerateRoute(RouteSettings routeSettings) {
    // push(routeSettings.name!);
    _pages.add(routeSettings.name!);
    return _createRoute(routeSettings);
  }

  MyPage _buildPage(String page) => MyPage(key: ObjectKey(page), name: page);

  // @override
  // Future<bool> popRoute() {
  //   print('-----------popRoute-------------');
  //   final NavigatorState navigator = navigatorKey?.currentState;
  //   if (navigator == null) return SynchronousFuture<bool>(false);
  //   return navigator.maybePop();
  // }
}

class _RouteDelegateInherited extends InheritedWidget {
  const _RouteDelegateInherited({
    required this.routeDelegate,
    required Widget child,
  }) : super(child: child);

  final MyRouteDelegate routeDelegate;

  @override
  bool updateShouldNotify(covariant _RouteDelegateInherited oldWidget) {
    return oldWidget.routeDelegate.pages != routeDelegate.pages;
  }
}

class MyPage extends Page {
  const MyPage({
    LocalKey? key,
    String? name,
  }) : super(key: key, name: name);

  @override
  Route createRoute(BuildContext context) => _createRoute(this);
}

Route _createRoute(RouteSettings settings) {
  Widget pageBuilder(BuildContext context) =>
      settings.name == '/' ? const MyHomePage() : MyItemPage(title: settings.name ?? '');
  return Platform.isIOS
      ? CupertinoPageRoute(settings: settings, builder: pageBuilder)
      : MaterialPageRoute(settings: settings, builder: pageBuilder);
}

extension on BuildContext {
  MyRouteDelegate get routeDelegate => MyRouteDelegate.maybeOf(this)!;

  MyRouteDelegate get routeDelegate2 => MyRouteDelegate.of(this);

  void push(String newRoute) => routeDelegate.push(newRoute);

  void pushAndRemoveExist(String newRoute) => routeDelegate.pushAndRemoveExist(newRoute);

  bool canPop() => routeDelegate.canPop();

  void pop() => routeDelegate.pop();

  void remove(String routeName) => routeDelegate.remove(routeName);

  void removeAll() => routeDelegate.removeAll();
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go'),
          onPressed: () => context.push('Route/1'),
        ),
      ),
    );
  }
}

class MyItemPage extends StatefulWidget {
  const MyItemPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyItemPageState createState() => _MyItemPageState();
}

class _MyItemPageState extends State<MyItemPage> {
  static int _pageIndex = 1;

  Future<dynamic> _showDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Is this being displayed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }

  void _remove() {
    context.remove('Route/2');
  }

  void _removeAll() {
    _pageIndex = 1;
    context.removeAll();
  }

  void _incrementCounter() => _pageIndex++;

  void _addRoute() {
    _incrementCounter();
    context.push('Route/$_pageIndex');
  }

  void _navAddRoute() {
    _incrementCounter();
    Navigator.of(context).pushNamed('Route/$_pageIndex');
  }

  void _addRouteTest() {
    _incrementCounter();
    context.pushAndRemoveExist('Route_Test/$_pageIndex');
  }

  void _navBack() {
    Navigator.of(context).pop();
  }

  void _back() {
    context.pop();
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
          children: const <Widget>[
            Text('Page List:'),
            PageListView(),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FloatingActionButton(
            heroTag: 'dialog',
            onPressed: () async {
              var dialogResult = await _showDialog();
              print('dialog result: $dialogResult');
            },
            tooltip: 'Show dialog',
            child: const Icon(Icons.message),
          ),
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: _remove,
            tooltip: 'Remove Route/2',
            child: const Icon(Icons.delete),
          ),
          FloatingActionButton(
            heroTag: 'removeAll',
            onPressed: _removeAll,
            tooltip: 'Remove All',
            child: const Icon(Icons.delete),
          ),
          FloatingActionButton(
            heroTag: 'addRoute',
            onPressed: _addRoute,
            tooltip: 'Add Route',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            backgroundColor: Colors.cyan,
            heroTag: 'navAddRoute',
            onPressed: _navAddRoute,
            tooltip: 'Nav Add Route',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            backgroundColor: Colors.green,
            heroTag: 'addRouteTest',
            onPressed: _addRouteTest,
            tooltip: 'Add Route Test',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'routerBack',
            backgroundColor: context.canPop() ? null : Colors.grey,
            onPressed: context.canPop() ? _back : null,
            tooltip: 'Router Back',
            child: const Icon(Icons.arrow_back_ios),
          ),
          FloatingActionButton(
            heroTag: 'navBack',
            backgroundColor: context.canPop() ? Colors.cyan : Colors.grey,
            onPressed: context.canPop() ? _navBack : null,
            tooltip: 'Nav Back',
            child: const Icon(Icons.arrow_back_ios),
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

class PageList extends StatelessWidget {
  const PageList({
    Key? key,
    this.pages,
  }) : super(key: key);

  final List<String>? pages;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      const TextSpan(text: '['),
      ...[
        for (String page in (pages ?? context.routeDelegate.pages)) ...[
          TextSpan(
            text: page,
            style: TextStyle(color: Colors.primaries[page.hashCode % Colors.primaries.length]),
          ),
          const TextSpan(text: ', '),
        ]
      ]..removeLast(),
      const TextSpan(text: ']'),
    ]));
  }
}

class PageListView extends StatelessWidget {
  const PageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('PageListView build-------------------');
    return Column(
      children: [
        PageList(pages: context.routeDelegate2.pages),
        const PageList(),
      ],
    );
  }
}
