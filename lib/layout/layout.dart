import 'package:flutter/widgets.dart';

import '../widget/absorb_stack.dart';
import 'adaptive.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (isDisplayDesktop(constraints.biggest)) {
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
              child: AbsorbStack(
                absorbIndex: 0,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(constraints.maxHeight / 90.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(constraints.maxHeight / 25.0),
                      child: child,
                    ),
                  ),
                  // ignore: prefer_asset_const
                  Image.asset('assets/images/iPhoneCase12.png'),
                ],
              ),
            ),
          );
        }

        return child;
      },
    );
  }
}
