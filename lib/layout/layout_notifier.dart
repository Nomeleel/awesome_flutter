import 'package:flutter/material.dart';

import 'adaptive.dart';

class Layout extends StatelessWidget {
  const Layout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final useConstraints = ValueNotifier(true);

    Widget wrapSwitchBuilder(Widget body) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          body,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => useConstraints.value = !useConstraints.value,
            child: Icon(
              useConstraints.value ? Icons.fullscreen : Icons.fullscreen_exit,
            ),
          ),
        ],
      );
    }

    final body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final preferDesktop = isDisplayDesktop(constraints.biggest);

        return ValueListenableBuilder<bool>(
          valueListenable: useConstraints,
          builder: (context, useConstraints, body) {
            if (preferDesktop && useConstraints) {
              return Container(
                padding: EdgeInsets.all(constraints.maxHeight / 7.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/BigSurBG.jpg'),
                  ),
                ),
                child: wrapSwitchBuilder(
                  AspectRatio(
                    aspectRatio: 727.0 / 1468.0,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(constraints.maxHeight / 90.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(constraints.maxHeight / 25.0),
                            child: body,
                          ),
                        ),
                        // ignore: prefer_asset_const
                        IgnorePointer(child: Image.asset('assets/images/iPhoneCase12.png')),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (preferDesktop) return wrapSwitchBuilder(body!);

            return body!;
          },
          child: child,
        );
      },
    );

    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: body,
    );
  }
}
