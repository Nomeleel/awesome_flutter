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
            if (useConstraints && preferDesktop) {
              return Container(
                padding: EdgeInsets.all(constraints.maxHeight / 7.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: const AssetImage('assets/images/BigSurBG.jpg'),
                  ),
                ),
                child: AspectRatio(
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
                      GestureDetector(
                        onTap: () => setState(() => useConstraints = false),
                        child: Icon(
                          Icons.fullscreen,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              textDirection: TextDirection.ltr,
              children: [
                this.child,
                if (preferDesktop)
                  GestureDetector(
                    onTap: () => setState(() => useConstraints = true),
                    child: Icon(
                      Icons.fullscreen_exit,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}
