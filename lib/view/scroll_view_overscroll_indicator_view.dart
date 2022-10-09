import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class ScrollViewOverscrollIndicatorView extends StatelessWidget {
  const ScrollViewOverscrollIndicatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Scroll View Overscroll Indicator View',
      body: Center(
        child: FractionallySizedBox(
          widthFactor: .77,
          heightFactor: .77,
          child: Container(
            color: Colors.purple.withOpacity(.7),
            child: ScrollConfiguration(
              behavior: const CustomScrollBehavior(),
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: 22,
                itemExtent: 50,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.primaries[index % Colors.primaries.length],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}
