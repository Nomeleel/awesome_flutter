import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../custom/animation/gesture_scale_transition.dart';
import '../custom/clipper/padding_radius_rect_clipper.dart';
import '../custom/cupertino/cupertino_slide_back.dart';
import '../helper/helper.dart';

class AppStoreCard extends StatelessWidget {
  const AppStoreCard({
    @required Key key,
    this.elevation,
    this.padding,
    this.radius,
    @required this.showBackgroundWidget,
    this.showForegroundWidget,
    this.detailWidget,
    this.isAlwayShow = true,
  })  : assert(key != null,
            'This key will be used as the Hero\'s tag. It must be unique and cannot be null.'),
        super(key: key);

  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry radius;
  final Widget showBackgroundWidget;
  final Widget showForegroundWidget;
  final Widget detailWidget;
  final bool isAlwayShow;

  EdgeInsets get edgeInsets => EdgeInsetsGeometryHelper.getEdgeInsets(padding);
  BorderRadius get borderRadius =>
      BorderRadiusGeometryHelper.getBorderRadius(radius);

  @override
  Widget build(BuildContext context) {
    return GestureScaleTransition(
      callBack: () => openDetailView(context),
      child: Hero(
        tag: key,
        child: buildCard(),
      ),
    );
  }

  Widget buildCard() {
    List<Widget> widgetList = List<Widget>();

    // build background elevation.
    if (elevation != null && elevation > 0) {
      widgetList.add(Positioned.fill(
        child: Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
          margin: padding,
          clipBehavior: Clip.antiAlias,
        ),
      ));
    }

    // build background foreground widget.
    var clipWidget = (Widget child, {EdgeInsets currentEdgeInsets}) {
      return ClipRRect(
        clipper: PRRectClipper(
          padding: currentEdgeInsets ?? edgeInsets,
          radius: borderRadius,
        ),
        child: child,
      );
    };

    widgetList.add(
      (edgeInsets != EdgeInsets.zero && borderRadius != BorderRadius.zero)
          ? clipWidget(showBackgroundWidget)
          : showBackgroundWidget,
    );

    widgetList.add(Positioned.fill(
      left: edgeInsets.left,
      top: edgeInsets.top,
      right: edgeInsets.right,
      bottom: edgeInsets.bottom,
      child: borderRadius != BorderRadius.zero
          ? clipWidget(
              showForegroundWidget,
              currentEdgeInsets: EdgeInsets.zero,
            )
          : showForegroundWidget,
    ));

    return Stack(children: widgetList);
  }

  Widget detailView(BuildContext context) {
    return Container(
        color: Colors.white,
        child: isAlwayShow
            ? ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      showBackgroundWidget,
                      if (showForegroundWidget != null)
                        Positioned.fill(
                          top: edgeInsets.top,
                          child: showForegroundWidget,
                        )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: detailWidget,
                  ),
                ],
              )
            : detailWidget);
  }

  void openDetailView(BuildContext context) {
    if (isAlwayShow) {
      SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return CupertinoSlideBack(
            child: Hero(
              tag: key,
              child: detailView(context),
            ),
            onBackCallBack: () {
              if (isAlwayShow) {
                SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[
                  SystemUiOverlay.top,
                  SystemUiOverlay.bottom
                ]);
              }
            },
          );
        },
      ),
    );
  }
}
