import 'package:flutter/material.dart';

import '../util/platforms.dart';

mixin UnsupportedPlatformPlaceholderMixin {
  late int? _platforms;
  bool get isSupportedPlatform => Platforms.containsCurrentPlatform(
      _platforms ?? setPlatform(supported: supportedPlatforms, unSupported: unSupportedPlatforms));

  int get supportedPlatforms => Platforms.all;

  int get unSupportedPlatforms => Platforms.none;

  int setPlatform({int supported = Platforms.all, int unSupported = Platforms.none}) {
    return _platforms = Platforms.minus(supported, unSupported);
  }

  Widget builder(BuildContext context);

  Widget placeholderBuilder(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '😂该平台不可用😂',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 50.0,
              ),
            ),
            Text(
              '请在以下平台上尝试:',
              style: TextStyle(
                color: Colors.purple[700],
                fontSize: 45.0,
              ),
            ),
            for (var item in Platforms.platformsParse(_platforms!))
              Text(
                '😊$item😊',
                style: TextStyle(
                  color: Colors.purple[700],
                  fontSize: 45.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return isSupportedPlatform ? builder(context) : placeholderBuilder(context);
  }
}
