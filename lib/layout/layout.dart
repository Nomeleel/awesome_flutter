import 'package:flutter/material.dart';

import 'adaptive.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    bool useConstraints = true;
    final child = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final preferDesktop = isDisplayDesktop(constraints.biggest);
        return StatefulBuilder(
          builder: (context, setState) {
            Widget wrapSwitchBuilder(Widget body) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  body,
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => useConstraints = !useConstraints),
                    child: Icon(
                      useConstraints ? Icons.fullscreen : Icons.fullscreen_exit,
                    ),
                  ),
                ],
              );
            }

            if (useConstraints && preferDesktop) {
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
                      textDirection: TextDirection.ltr,
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

            if (preferDesktop) return wrapSwitchBuilder(this.child);

            return this.child;
          },
        );
      },
    );

    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: child,
    );
  }
}
