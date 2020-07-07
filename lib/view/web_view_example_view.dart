import 'dart:async';

import 'package:awesome_flutter/widget/side_panel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExampleView extends StatefulWidget {
  WebViewExampleView({Key key, this.initialUrl = 'https://flutter.cn/'})
      : super(key: key);

  final String initialUrl;

  @override
  _WebViewExampleViewState createState() => _WebViewExampleViewState();
}

class _WebViewExampleViewState extends State<WebViewExampleView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext rootContext) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                print('Close web view.');
                Navigator.of(context).pop();
              },
            ),
            title: WebViewTitle(key: WebViewTitle.globalKey),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  print('more action.');
                  SidePanel.of(context).switchPanel();
                },
              ),
            ],
          ),
          body: Builder(
            builder: (BuildContext context) => WebView(
              initialUrl: widget.initialUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                  name: 'Toaster',
                  onMessageReceived: (JavascriptMessage message) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(message.message)),
                    );
                  },
                ),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                print('nav: ${request.url}');

                // Check if cross domain
                // return NavigationDecision.prevent;

                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                // Can add a progress bar.
              },
              onPageFinished: (String url) async {
                // Update title.
                WebViewTitle.getState()
                    .changeTitle(await (await _controller.future).getTitle());
                // Update nav bar.
                WebViewNavigationBar.getState()
                    .update(await _controller.future);
              },
              onWebResourceError: (WebResourceError error) {
                print('Page throw error: $error');
              },
              gestureNavigationEnabled: true,
            ),
          ),
          bottomNavigationBar:
              WebViewNavigationBar(key: WebViewNavigationBar.globalKey),
        ),
        SidePanel(
          mainAxisHeight: 300,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffdddddd),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.refresh),
                  onTap: () async {
                    (await _controller.future).reload();
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class WebViewTitle extends StatefulWidget {
  const WebViewTitle({Key key, this.title}) : super(key: key);

  static final globalKey = GlobalKey<_WebViewTitleState>();

  final String title;

  @override
  _WebViewTitleState createState() => _WebViewTitleState();

  static _WebViewTitleState getState() {
    return globalKey.currentState;
  }
}

class _WebViewTitleState extends State<WebViewTitle> {
  String _title;

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Text(_title);
  }

  void changeTitle(String title) {
    setState(() {
      _title = title;
    });
  }
}

class WebViewNavigationBar extends StatefulWidget {
  const WebViewNavigationBar({Key key, this.controller}) : super(key: key);

  static final globalKey = GlobalKey<_WebViewNavigationBarState>();

  final WebViewController controller;

  @override
  _WebViewNavigationBarState createState() => _WebViewNavigationBarState();

  static _WebViewNavigationBarState getState() {
    return globalKey.currentState;
  }
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
    return (_canGoBack || _canGoForward)
        ? bottomAppBar()
        : Container(
            height: 0.0,
            width: 0.0,
          );
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _canGoBack
                ? () {
                    _webViewController.goBack();
                  }
                : null,
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _canGoForward
                ? () {
                    _webViewController.goForward();
                  }
                : null,
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
