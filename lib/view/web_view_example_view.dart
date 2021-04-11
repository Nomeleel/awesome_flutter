import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../mixin/unsupported_platform_placeholder_mixin.dart';

String separator = "😊";

class WebViewExampleView extends StatefulWidget {
  const WebViewExampleView({Key key, this.initialUrl = 'https://flutter.cn/'}) : super(key: key);

  final String initialUrl;

  @override
  _WebViewExampleViewState createState() => _WebViewExampleViewState();
}

class _WebViewExampleViewState extends State<WebViewExampleView> with UnsupportedPlatformPlaceholderMixin {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  ValueNotifier changed;

  ValueNotifier<double> progress;

  @override
  void initState() {
    super.initState();
    setPlatform(supported: 3);

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    progress = ValueNotifier(.0);
    changed = ValueNotifier('Web View Example View');
  }

  @override
  Widget builder(BuildContext rootContext) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            print('Close Web View.');
            goBack();
          },
        ),
        title: topTitle(),
        actions: <Widget>[menuButton()],
        bottom: linearProgressIndicator(),
      ),
      body: webViewBuilder(),
      bottomNavigationBar: WebViewNavigationBar(key: WebViewNavigationBar.globalKey),
    );
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Widget topTitle() {
    return WebViewChangedFutureBuilder<String>(
      controller: _controller.future,
      changed: changed,
      future: (WebViewController controller) => controller.getTitle(),
      builder: (BuildContext context, String title, Widget child) => Text(title),
    );
  }

  Widget menuButton() {
    return WebViewControllerBuilder(
      controller: _controller.future,
      builder: (BuildContext context, WebViewController controller) {
        return IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              builder: (BuildContext context) => Container(
                height: 400.0,
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: MenuPanel(
                        controller: controller,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: goBack,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.0),
                        child: const Text('取消'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget linearProgressIndicator() {
    return PreferredSize(
      preferredSize: Size.fromHeight(2.0),
      child: ValueListenableBuilder(
        valueListenable: progress,
        builder: (BuildContext context, double value, Widget child) => LinearProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation(
            ColorTween(
              begin: Colors.purple,
              end: Theme.of(context).primaryColor,
            ).transform(value),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Builder webViewBuilder() {
    return Builder(
      builder: (BuildContext context) => WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) => _controller.complete(controller),
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
            name: 'Toaster',
            onMessageReceived: (JavascriptMessage message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message.message)),
              );
            },
          ),
          JavascriptChannel(
            name: 'Dialog',
            onMessageReceived: (JavascriptMessage message) {
              final messagePlus = message.message.split(separator);
              showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text(messagePlus.first),
                  content: Text(messagePlus.last),
                  actions: [
                    CupertinoButton(
                      child: Text('取消'),
                      onPressed: goBack,
                    ),
                    CupertinoButton(
                      child: Text('确定'),
                      onPressed: goBack,
                    ),
                  ],
                ),
              );
            },
          ),
        },
        navigationDelegate: (NavigationRequest request) {
          print('Nav To: ${request.url}');

          // Check if cross domain
          // return NavigationDecision.prevent;

          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page onPageStarted: $url');
        },
        onProgress: onProgress,
        onPageFinished: onPageFinished,
        onWebResourceError: (WebResourceError error) {
          print('Page throw error: ${error.detail}');
        },
        gestureNavigationEnabled: true,
      ),
    );
  }

  void onProgress(int prs) {
    print("Page is loading (progress : $prs%)");
    progress.value = prs / 100;
  }

  void onPageFinished(String url) async {
    print('Page onPageFinished: $url');

    // Update Nav Bar.
    WebViewNavigationBar.of().update(await _controller.future);

    // changeed
    changed.value = url;
  }
}

class WebViewNavigationBar extends StatefulWidget {
  const WebViewNavigationBar({Key key, this.controller}) : super(key: key);

  static final globalKey = GlobalKey<_WebViewNavigationBarState>();

  final WebViewController controller;

  @override
  _WebViewNavigationBarState createState() => _WebViewNavigationBarState();

  static _WebViewNavigationBarState of() => globalKey.currentState;
}

class _WebViewNavigationBarState extends State<WebViewNavigationBar> {
  WebViewController _webViewController;
  bool _canGoBack;
  bool _canGoForward;

  @override
  void initState() {
    super.initState();

    changedWithController(widget.controller);
  }

  void changedWithController(WebViewController controller) async {
    if (controller != null) {
      _webViewController = controller;
      _canGoBack = await controller.canGoBack();
      _canGoForward = await controller.canGoForward();
    } else {
      _canGoBack = false;
      _canGoForward = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_canGoBack || _canGoForward) ? bottomAppBar() : SizedBox();
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _canGoBack ? _webViewController.goBack : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _canGoForward ? _webViewController.goForward : null,
          ),
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: _webViewController.reload,
          ),
        ],
      ),
    );
  }

  void update(WebViewController controller) {
    setState(() {
      changedWithController(controller);
    });
  }
}

class MenuPanel extends StatelessWidget {
  const MenuPanel({@required this.controller});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ActionItem(Icons.home, 'Home', goHome),
        ActionItem(Icons.refresh, 'Refresh', refresh),
        ActionItem(Icons.arrow_downward, 'Down', scrollDown),
        ActionItem(Icons.arrow_upward, 'Top', jumpTop),
        ActionItem(Icons.my_location, 'Position', showPosition),
        ActionItem(Icons.place, 'Url', showUrl),
        ActionItem(Icons.add, 'Cache', addCache),
        ActionItem(Icons.data_usage, 'Caches', showCaches),
        ActionItem(Icons.delete_forever_sharp, 'Clear', clear),
        ActionItem(Icons.assignment_ind, 'User Agent', showUserAgent),
        ActionItem(Icons.label, 'Cookie', showCookie),
        ActionItem(Icons.edit, 'Console', null),
      ],
    );
  }

  Future<void> goHome() async {
    await controller.loadUrl('https://flutter.dev/');
  }

  Future<void> refresh() async {
    await controller.reload();
  }

  Future<void> scrollDown() async {
    await controller.scrollBy(0, 100);
  }

  Future<void> jumpTop() async {
    await controller.scrollTo(0, 0);
  }

  Future<void> showPosition() async {
    await showDialog(
      "Position",
      'x: ${await controller.getScrollX()}; '
          'y: ${await controller.getScrollY()};',
    );
  }

  Future<void> showUrl() async {
    await showDialog("Url", await controller.currentUrl());
  }

  void addCache() async {
    await controller.evaluateJavascript('caches.open("Add cache test"); localStorage["testLocalStorage"] = "Test";');
  }

  Future<void> showCaches() async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Dialog.postMessage("Caches$separator" + caches))');
  }

  Future<void> clear() async {
    await controller.clearCache();
  }

  Future<void> showUserAgent() async {
    await showScriptDialog('UserAgent', 'navigator.userAgent');
  }

  Future<void> showCookie() async {
    await showScriptDialog('Cookie', 'document.cookie');
  }

  Future<void> toastString(String message) async {
    await toastScript('"$message"');
  }

  Future<void> toastScript(String script) async {
    await controller.evaluateJavascript('Toaster.postMessage($script);');
  }

  Future<void> showScriptDialog(String title, String script) async {
    await controller.evaluateJavascript('Dialog.postMessage("$title$separator" + $script);');
  }

  Future<void> showDialog(String title, String content) async {
    await controller.evaluateJavascript('Dialog.postMessage("$title$separator$content");');
  }
}

class ActionItem extends StatelessWidget {
  const ActionItem(
    this.iconData,
    this.label,
    this.action, {
    Key key,
  }) : super(key: key);

  final IconData iconData;
  final String label;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Icon(iconData),
            ),
            Text(label)
          ],
        ),
      ),
    );
  }
}

class WebViewControllerBuilder extends StatelessWidget {
  const WebViewControllerBuilder({
    @required this.controller,
    @required this.builder,
    this.placeholdBuilder,
  });

  final Future<WebViewController> controller;
  final Widget Function(BuildContext context, WebViewController controller) builder;
  final WidgetBuilder placeholdBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.connectionState == ConnectionState.done) {
          return builder(context, controller.data);
        }
        return placeholdBuilder?.call(context) ?? SizedBox();
      },
    );
  }
}

class WebViewChangedFutureBuilder<T> extends StatelessWidget {
  WebViewChangedFutureBuilder({
    @required this.controller,
    @required this.changed,
    @required this.future,
    @required this.builder,
    this.child,
  }) : this.initialData = changed.value;

  final Future<WebViewController> controller;
  final ValueNotifier changed;
  final T initialData;
  final Future<T> Function(WebViewController controller) future;
  final ValueWidgetBuilder<T> builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WebViewControllerBuilder(
      controller: controller,
      builder: listenableBuilder,
      placeholdBuilder: placeholdBuilder,
    );
  }

  Widget listenableBuilder(BuildContext context, WebViewController controller) {
    return ValueListenableBuilder(
      valueListenable: changed,
      builder: (BuildContext context, dynamic value, Widget child) {
        return FutureBuilder<T>(
          future: future(controller),
          initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
            if (snapshot.connectionState == ConnectionState.none || (snapshot.data?.toString()?.isEmpty ?? true)) {
              return placeholdBuilder(context);
            }

            return builder(context, snapshot.data, child);
          },
        );
      },
    );
  }

  Widget placeholdBuilder(BuildContext context) => builder(context, initialData, child);
}

extension WebResourceErrorExtension on WebResourceError {
  String get detail {
    return 'WebResourceError Detail: \n'
        'errorCode: $errorCode\n'
        'errorType: $errorType\n'
        'description: $description\n'
        'domain: $domain\n'
        'failingUrl: $failingUrl\n';
  }
}
