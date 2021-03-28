import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin UnsupportedPlatformPlaceholderMixin {
  int _platforms = Platforms.all;
  bool get isSupportedPlatform => Platforms.containsCurrentPlatform(_platforms);

  int setPlatform({int supported, int unSupported = 0}) {
    _platforms = supported ?? Platforms.all;
    _platforms -= unSupported;
    return _platforms;
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
            for (var item in Platforms.platformsParse(_platforms))
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

class Platforms {
  static const Map<String, int> platformMap = {
    'Android': 1,
    'iOS': 2,
    'MacOS': 4,
    'Windows': 8,
    'Linux': 16,
    'Fuchsia': 32,
    'Web': 64,
  };
  static final int length = platformMap.length;
  static final int all = math.pow(2, length) - 1;

  static final String currentPlatform = kIsWeb ? 'web' : Platform.operatingSystem;

  static List<String> platformsParse(int platforms) {
    final String platformBinStr = platforms.toRadixString(2);
    return platformMap.keys.take(platformBinStr.length).where(() {
      int index = 0;
      return (element) {
        index++;
        return platformBinStr[platformBinStr.length - index] == '1';
      };
    }()).toList();
  }

  static bool containsCurrentPlatform(int platforms) {
    // final String platformBinStr = platforms.toRadixString(2);
    // int index = length - platformMap.keys.toList().indexWhere((e) => e.toLowerCase() == currentPlatform) - 1;
    // return index < 0 ? false : platformBinStr[index] == '1';

    return platformsParse(platforms).any((e) => e.toLowerCase() == currentPlatform);
  }
}