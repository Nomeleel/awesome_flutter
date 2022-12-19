import 'package:flutter/material.dart';

import 'adaptive.dart';

class Layout extends StatelessWidget {
  const Layout({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final useConstraints = ValueNotifier(true);

    Widget wrapSwitchBuilder(Widget body) => Stack(
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

    final body = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final preferDesktop = isDisplayDesktop(constraints.biggest);

        return ValueListenableBuilder<bool>(
          valueListenable: useConstraints,
          builder: (context, useConstraints, body) {
            if (preferDesktop) {
              if (useConstraints) {
                return Container(
                  padding: EdgeInsets.all(constraints.maxHeight / 7.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: const AssetImage('assets/images/BigSurBG.jpg'),
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
                              child: this.child,
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

              return wrapSwitchBuilder(body!);
            }

            return body!;
          },
          child: child,
        );
      },
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: body,
    );
  }
}
