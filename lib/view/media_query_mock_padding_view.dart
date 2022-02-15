/// Reference
/// Youtube: https://www.youtube.com/watch?v=ceCo8U0XHqw&ab_channel=Flutter
/// DartPad: https://goo.gle/3qrgmoH
import 'package:flutter/material.dart';

import '../mixin/unsupported_platform_placeholder_mixin.dart';
import '../util/platforms.dart';

class MediaQueryMockPaddingView extends StatefulWidget {
  const MediaQueryMockPaddingView({Key? key}) : super(key: key);

  @override
  State<MediaQueryMockPaddingView> createState() => _MediaQueryMockPaddingViewState();
}

class _MediaQueryMockPaddingViewState extends State<MediaQueryMockPaddingView>
    with UnsupportedPlatformPlaceholderMixin {
  @override
  void initState() {
    super.initState();

    setPlatform(supported: Platforms.macos + Platforms.linux + Platforms.windows + Platforms.web);
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: const <Widget>[
          FullStack(),
        ],
      ),
    );
  }
}

// animation
class FullStack extends StatefulWidget {
  const FullStack({Key? key}) : super(key: key);

  @override
  State<FullStack> createState() => _FullStackState();
}

class _FullStackState extends State<FullStack> {
  bool _safeArea = true;
  bool _fakeKeyboard = false;

  final double top = 20;
  final double bottom = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final keyboardTextStyle = Theme.of(context).textTheme.headline2;
              late final EdgeInsets viewPadding;
              late final EdgeInsets padding;

              late final EdgeInsets positioning;

              final verticalPadding = EdgeInsets.only(top: top, bottom: bottom);

              if (!_safeArea && !_fakeKeyboard) {
                viewPadding = verticalPadding;
                padding = verticalPadding;
                positioning = EdgeInsets.zero;
              } else if (_safeArea && !_fakeKeyboard) {
                viewPadding = EdgeInsets.zero;
                padding = EdgeInsets.zero;
                positioning = verticalPadding;
              } else if (!_safeArea && _fakeKeyboard) {
                viewPadding = verticalPadding;
                padding = EdgeInsets.only(top: top);
                positioning = EdgeInsets.zero;
              } else {
                // Have both
                viewPadding = EdgeInsets.only(bottom: bottom);
                padding = EdgeInsets.zero;
                positioning = EdgeInsets.only(top: top);
              }

              final MediaQueryData mq = MediaQuery.of(context).copyWith(
                padding: padding,
                viewPadding: viewPadding,
                viewInsets: EdgeInsets.only(
                  bottom: _fakeKeyboard ? 300 : 0,
                ),
              );
              return Stack(
                children: <Widget>[
                  // Top notch (heh)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    left: mq.size.width / 4,
                    top: top - 10,
                    child: Container(
                      height: 5,
                      width: mq.size.width / 2,
                      color: Colors.grey[800],
                    ),
                  ),
                  // Bottom notch
                  if (!_fakeKeyboard)
                    Positioned(
                      left: mq.size.width / 4,
                      bottom: bottom - 10,
                      child: Container(
                        height: 5,
                        width: mq.size.width / 2,
                        color: Colors.grey[800],
                      ),
                    ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Fake keyboard is ${_fakeKeyboard ? "REVEALED" : "HIDDEN"}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Switch(
                          value: _fakeKeyboard,
                          onChanged: (value) {
                            setState(() {
                              _fakeKeyboard = value;
                            });
                          },
                        ),
                        Text(
                          'SafeArea is ${_safeArea ? "ON" : "OFF"}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Switch(
                          value: _safeArea,
                          onChanged: (value) {
                            setState(() {
                              _safeArea = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    top: positioning.top,
                    left: mq.size.width / 2.2,
                    child: MediaQueryTopInfo(mediaQueryData: mq),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    top: mq.size.height / 2.5 - mq.viewInsets.bottom / 2,
                    left: positioning.left,
                    child: MediaQueryLeftInfo(mediaQueryData: mq),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    top: mq.size.height / 2.5 - mq.viewInsets.bottom / 2,
                    right: positioning.right,
                    child: MediaQueryRightInfo(mediaQueryData: mq),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    bottom: positioning.bottom + mq.viewInsets.bottom,
                    left: mq.size.width / 2.2,
                    child: MediaQueryBottomInfo(mediaQueryData: mq),
                  ),
                  if (_fakeKeyboard)
                    Positioned(
                      bottom: 0,
                      width: mq.size.width,
                      height: 300,
                      child: Container(
                        color: Colors.grey[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('K', style: keyboardTextStyle),
                            Text('E', style: keyboardTextStyle),
                            Text('Y', style: keyboardTextStyle),
                            Text('B', style: keyboardTextStyle),
                            Text('O', style: keyboardTextStyle),
                            Text('A', style: keyboardTextStyle),
                            Text('R', style: keyboardTextStyle),
                            Text('D', style: keyboardTextStyle),
                          ],
                        ),
                      ),
                    )
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class MediaQueryBottomInfo extends StatelessWidget {
  const MediaQueryBottomInfo({Key? key, required this.mediaQueryData}) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    final viewInsets = mediaQueryData.viewInsets;
    final viewPadding = mediaQueryData.viewPadding;
    final padding = mediaQueryData.padding;
    return Column(
      children: <Widget>[
        const Text('BOTTOM'),
        Text('Padding: ${padding.bottom}'),
        Text('ViewPadding: ${viewPadding.bottom}'),
        Text('ViewInsets: ${viewInsets.bottom}'),
      ],
    );
  }
}

class MediaQueryTopInfo extends StatelessWidget {
  const MediaQueryTopInfo({Key? key, required this.mediaQueryData}) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    final viewInsets = mediaQueryData.viewInsets;
    final viewPadding = mediaQueryData.viewPadding;
    final padding = mediaQueryData.padding;
    return Column(
      children: <Widget>[
        const Text('TOP'),
        Text('Padding: ${padding.top}'),
        Text('ViewPadding: ${viewPadding.top}'),
        Text('ViewInsets: ${viewInsets.top}'),
      ],
    );
  }
}

class MediaQueryLeftInfo extends StatelessWidget {
  const MediaQueryLeftInfo({Key? key, required this.mediaQueryData}) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    final viewInsets = mediaQueryData.viewInsets;
    final viewPadding = mediaQueryData.viewPadding;
    final padding = mediaQueryData.padding;
    return Column(
      children: <Widget>[
        const Text('LEFT'),
        Text('Padding: ${padding.left}'),
        Text('ViewPadding: ${viewPadding.left}'),
        Text('ViewInsets: ${viewInsets.left}'),
      ],
    );
  }
}

class MediaQueryRightInfo extends StatelessWidget {
  const MediaQueryRightInfo({Key? key, required this.mediaQueryData}) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    final viewInsets = mediaQueryData.viewInsets;
    final viewPadding = mediaQueryData.viewPadding;
    final padding = mediaQueryData.padding;
    return Column(
      children: <Widget>[
        const Text('RIGHT'),
        Text('Padding: ${padding.right}'),
        Text('ViewPadding: ${viewPadding.right}'),
        Text('ViewInsets: ${viewInsets.right}'),
      ],
    );
  }
}
