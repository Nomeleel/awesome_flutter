import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../mixin/unsupported_platform_placeholder_mixin.dart';
import '../util/platforms.dart';
import '../widget/scaffold_view.dart';

// ignore: must_be_immutable
class NativePlatformView extends StatelessWidget with UnsupportedPlatformPlaceholderMixin {
  NativePlatformView({Key key}) : super(key: key);

  @override
  int get supportedPlatforms => Platforms.android + Platforms.ios;

  @override
  Widget builder(BuildContext context) {
    return ScaffoldView(
      title: 'Native Platform View',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 100,
            ),
            Text(
              'Current Platform: ${Platforms.currentPlatform}',
              style: Theme.of(context).textTheme.headline5,
            ),
            navToButton(context),
          ],
        ),
      ),
    );
  }

  Widget navToButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Route route = Platform.isAndroid
            ? MaterialPageRoute(builder: (BuildContext context) => AndroidView())
            : CupertinoPageRoute(builder: (BuildContext context) => IosView());
        Navigator.of(context).push(route);
      },
      child: Text('Go To Native View'),
    );
  }
}

// ignore: must_be_immutable
class AndroidView extends StatelessWidget with UnsupportedPlatformPlaceholderMixin {
  AndroidView({Key key}) : super(key: key);

  @override
  int get supportedPlatforms => Platforms.android;

  @override
  Widget builder(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}

// ignore: must_be_immutable
class IosView extends StatelessWidget with UnsupportedPlatformPlaceholderMixin {
  IosView({Key key}) : super(key: key);

  @override
  int get supportedPlatforms => Platforms.ios;

  @override
  Widget builder(BuildContext context) {
    final String viewType = '<ios-platform-view-type>';

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
