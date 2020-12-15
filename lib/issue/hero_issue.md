# The target Hero widget is build three times

# Steps to Reproduce

## Below is my code.

```dart
import 'package:flutter/material.dart';

class HeroDemoView extends StatefulWidget {
  const HeroDemoView({Key key}) : super(key: key);

  @override
  _HeroDemoViewState createState() => _HeroDemoViewState();
}

class _HeroDemoViewState extends State<HeroDemoView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: 'Hero',
        child: Center(
          child: Container(
            height: 77,
            width: 77,
            color: Colors.purple,
          ),
        ),   
      ),
      onTap: () {
        print('Open second page...');
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Hero(
              tag: 'Hero',
              child: SecondPage(),
            );
          }
        ));
      },
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Second page build...');
    return Container(
      color: Colors.blue,
    );
  }
}

```
When I tap on the purple container

**Expected results:**

```
flutter: Open second page...
flutter: Second page build...
```

**Actual results:**

```
flutter: Open second page...
flutter: Second page build...
flutter: Second page build...
flutter: Second page build...
```

**The second page is build three times**

<details>
  <summary>Logs</summary>

```
flutter doctor -v

[✓] Flutter (Channel stable, v1.17.3, on Mac OS X 10.15.5 19F101, locale zh-Hans-CN)
    • Flutter version 1.17.3 at /Library/Flutter/flutter
    • Framework revision b041144f83 (4 weeks ago), 2020-06-04 09:26:11 -0700
    • Engine revision ee76268252
    • Dart version 2.8.4

[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.0)
    • Android SDK at /Users/choonlay/Library/Android/sdk
    • Platform android-30, build-tools 30.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 11.5)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 11.5, Build version 11E608c
    • CocoaPods version 1.9.3

[✓] Android Studio (version 4.0)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin version 46.0.2
    • Dart plugin version 193.7361
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)

[✓] VS Code (version 1.46.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.12.0

[✓] Connected device (1 available)
    • iPhone 11 Pro • EC9436BA-C9A8-4703-B0BE-1AC9AC9A369F • ios • com.apple.CoreSimulator.SimRuntime.iOS-13-5 (simulator)

• No issues found!

```

</details>
