import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrollViewJumpTopView extends StatefulWidget {
  const ScrollViewJumpTopView({Key key}) : super(key: key);

  @override
  _ScrollViewJumpTopViewState createState() => _ScrollViewJumpTopViewState();
}

class _ScrollViewJumpTopViewState extends State<ScrollViewJumpTopView> {
  @override
  Widget build(BuildContext context) {
    return ScrollViewJumpTop(
      child: ListView.builder(
        itemCount: 77,
        itemBuilder: (BuildContext context, int index) => Container(
          height: 77.77,
          margin: EdgeInsets.all(7.7),
          color: Colors.primaries[index % 16],
          alignment: Alignment.center,
          child: RaisedButton(
            child: const Text('Go'),
            onPressed: () {
              ScrollableState scrollableState = Scrollable.of(context);
              print(scrollableState);
            },
          ),
        ),
      ),
    );
  }
}

class ScrollViewJumpTop extends StatefulWidget {
  ScrollViewJumpTop({Key key, this.child, this.triggerHeight, this.jumpTopBuilder}) : super(key: key);

  final Widget child;
  final double triggerHeight;
  final WidgetBuilder jumpTopBuilder;

  @override
  _ScrollViewJumpTopState createState() => _ScrollViewJumpTopState();
}

class _ScrollViewJumpTopState extends State<ScrollViewJumpTop> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      findScrollableState();
    });

    return widget.child;
  }

  findScrollableState() {
    (context as Element).visitChildren((element) {
      if (element is BuildContext) {
        print(element);
        ScrollableState scrollableState = Scrollable.of(context);
        print(scrollableState);
        (element as Element).visitChildren((element2) {
          if (element2 is BuildContext) {
            ScrollableState scrollableState2 = Scrollable.of(element2);
            print(scrollableState2);
          }
        });
      }
    });
  }
}
