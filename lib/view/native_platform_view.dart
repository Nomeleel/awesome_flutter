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

class NativePlatformView extends StatefulWidget {
  const NativePlatformView({Key key}) : super(key: key);

  @override
  _NativePlatformViewState createState() => _NativePlatformViewState();
}

class _NativePlatformViewState extends State<NativePlatformView> with UnsupportedPlatformPlaceholderMixin {
  static const MethodChannel _methodChannel = MethodChannel('awesome_flutter/platform_view/method_channel');

  @override
  void initState() {
    super.initState();

    setPlatform(supported: Platforms.android + Platforms.ios);

    _methodChannel.setMethodCallHandler(methodCallHandler);
  }

  Future<dynamic> methodCallHandler(MethodCall call) async {
    print('-----------');
    print(call.method);
    print('-----------');
    switch (call.method) {
      case "showViewBottomSheet":
      default:
        await showViewBottomSheet(call.arguments);
    }
  }

  @override
  Widget builder(BuildContext context) => mainView(context);

  Widget mainView(BuildContext context, [String title]) {
    return ScaffoldView(
      title: title ?? 'Native Platform View',
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
            if (Platform.isIOS) openAppStoreProductView(),
            if (Platform.isAndroid) openAndroidShareView(),
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

  Widget openAppStoreProductView() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey[100]),
        foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
      ),
      child: const Text('Open WeChat of app product view in iOS view'),
      onPressed: () async {
        // 微信bundleID
        await _methodChannel.invokeMethod<int>('openAppStoreProductView', '414478124');
      },
    );
  }

  Widget openAndroidShareView() {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green[700])),
      child: const Text('Open Android Share View'),
      onPressed: () async {
        await _methodChannel.invokeMethod<int>('openShareView', '😊This is text from Flutter view.😊');
      },
    );
  }

  Future<dynamic> showViewBottomSheet(String from) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext context) => mainView(context, 'From $from View'),
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
