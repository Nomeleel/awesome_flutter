import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
            ? MaterialPageRoute(builder: (BuildContext context) => AndroidViewHybridComposition())
            : CupertinoPageRoute(builder: (BuildContext context) => IosView());
        Navigator.of(context).push(route);
      },
      child: Text('Go To Native View'),
    );
  }
}

// ignore: must_be_immutable
class AndroidViewHybridComposition extends StatelessWidget with UnsupportedPlatformPlaceholderMixin {
  AndroidViewHybridComposition({Key key}) : super(key: key);

  @override
  int get supportedPlatforms => Platforms.android;

  @override
  Widget builder(BuildContext context) {
    final String viewType = '<android-platform-view-type>';

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}

@Deprecated('推荐使用AndroidViewHybridComposition')
// ignore: must_be_immutable
class AndroidViewVirtualDisplay extends StatelessWidget with UnsupportedPlatformPlaceholderMixin {
  AndroidViewVirtualDisplay({Key key}) : super(key: key);

  @override
  int get supportedPlatforms => Platforms.android;

  @override
  Widget builder(BuildContext context) {
    final String viewType = '<android-platform-view-type>';

    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
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
