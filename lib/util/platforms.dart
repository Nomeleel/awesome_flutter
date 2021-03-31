import 'dart:io';

import 'package:flutter/foundation.dart';

class Platforms {
  static const Map<String, int> platformMap = {
    'Android': android,
    'iOS': ios,
    'MacOS': macos,
    'Windows': windows,
    'Linux': linux,
    'Fuchsia': fuchsia,
    'Web': web,
  };

  static int get length => platformMap.length;

  static const int none = 0;

  static const int android = 2 >> 1;

  static const int ios = 2;

  static const int macos = 2 << 1;

  static const int windows = 2 << 2;

  static const int linux = 2 << 3;

  static const int fuchsia = 2 << 4;

  static const int web = 2 << 5;
  
  static const int all = 2 << 7 - 1;
  //static final int all = (2 << length) - 1;

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

  static int minus(int a, int b) {
    return a & (~b);
  }
}
