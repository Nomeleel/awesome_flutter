import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusableActionDetectorTestView extends StatefulWidget {
  FocusableActionDetectorTestView({Key key}) : super(key: key);

  @override
  _FocusableActionDetectorTestViewState createState() => _FocusableActionDetectorTestViewState();
}

class _FocusableActionDetectorTestViewState extends State<FocusableActionDetectorTestView> {
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget();
  }
}

// 推荐使用KeyboardListener
class FadButton4 extends StatelessWidget {
  const FadButton4({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final show = ValueNotifier(false);
    final toggleShow = () => show.value = !show.value;
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (rawKeyEvent) {
        if (rawKeyEvent is RawKeyDownEvent) {
          if (rawKeyEvent.logicalKey == LogicalKeyboardKey.keyR) {
            toggleShow();
          }
        }
      },
      child: GestureDetector(
        onTap: toggleShow,
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.brown,
              child: child,
            ),
            ValueListenableBuilder(
              valueListenable: show,
              builder: (BuildContext context, bool show, Widget child) {
                return Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.all(10.0),
                  color: show ? Colors.indigo : Colors.transparent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FadButton3 extends StatelessWidget {
  const FadButton3({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final show = ValueNotifier(false);
    final toggleShow = () => show.value = !show.value;
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (keyEvent) {
        if (keyEvent is KeyDownEvent) {
          if (keyEvent.logicalKey == LogicalKeyboardKey.keyY) {
            toggleShow();
          }
        }
      },
      child: GestureDetector(
        onTap: toggleShow,
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.teal,
              child: child,
            ),
            ValueListenableBuilder(
              valueListenable: show,
              builder: (BuildContext context, bool show, Widget child) {
                return Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.all(10.0),
                  color: show ? Colors.cyan : Colors.transparent,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FadButton2 extends StatefulWidget {
  const FadButton2({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<FadButton2> createState() => _FadButton2State();
}

class _FadButton2State extends State<FadButton2> {
  final show = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    RawKeyboard.instance.addListener(_keyboardListener);
  }

  void _toggleShow() => show.value = !show.value;

  void _keyboardListener(RawKeyEvent rawKeyEvent) {
    if (rawKeyEvent is RawKeyDownEvent) {
      if (rawKeyEvent.logicalKey == LogicalKeyboardKey.keyZ) {
        _toggleShow();
      }
      if (rawKeyEvent.logicalKey == LogicalKeyboardKey.keyX) {
        print('FadButton2 listener X -------------');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleShow,
      child: Row(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.purple,
          child: widget.child,
        ),
        ValueListenableBuilder(
          valueListenable: show,
          builder: (BuildContext context, bool show, Widget child) {
            return Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.all(10.0),
              color: show ? Colors.amber : Colors.transparent,
            );
          },
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    RawKeyboard.instance.removeListener(_keyboardListener);
  }
}

// From https://api.flutter.dev/flutter/widgets/FocusableActionDetector-class.html#widgets.FocusableActionDetector.1
class FadButton extends StatefulWidget {
  const FadButton({
    Key key,
    @required this.onPressed,
    @required this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<FadButton> createState() => _FadButtonState();
}

class _FadButtonState extends State<FadButton> {
  bool _focused = false;
  bool _hovering = false;
  bool _on = false;
  Map<Type, Action<Intent>> _actionMap;
  final Map<ShortcutActivator, Intent> _shortcutMap = const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.keyX): ActivateIntent(),
  };

  @override
  void initState() {
    super.initState();
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<Intent>(
        onInvoke: (Intent intent) => _toggleState(),
      ),
    };
  }

  Color get color {
    Color baseColor = Colors.lightBlue;
    if (_focused) {
      baseColor = Color.alphaBlend(Colors.black.withOpacity(0.25), baseColor);
    }
    if (_hovering) {
      baseColor = Color.alphaBlend(Colors.black.withOpacity(0.1), baseColor);
    }
    return baseColor;
  }

  void _toggleState() {
    setState(() {
      _on = !_on;
    });
  }

  void _handleFocusHighlight(bool value) {
    setState(() {
      _focused = value;
    });
  }

  void _handleHoveHighlight(bool value) {
    setState(() {
      _hovering = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleState,
      child: FocusableActionDetector(
        actions: _actionMap,
        shortcuts: _shortcutMap,
        onShowFocusHighlight: _handleFocusHighlight,
        onShowHoverHighlight: _handleHoveHighlight,
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              color: color,
              child: widget.child,
            ),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.all(10.0),
              color: _on ? Colors.blue : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusableActionDetector Example'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(onPressed: () {}, child: const Text('Press Me')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadButton(onPressed: () {}, child: const Text('And Me (X)')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadButton2(child: const Text('And Me (Z)')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadButton3(child: const Text('And Me (Y)')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadButton4(child: const Text('And Me (R)')),
            ),
          ],
        ),
      ),
    );
  }
}
