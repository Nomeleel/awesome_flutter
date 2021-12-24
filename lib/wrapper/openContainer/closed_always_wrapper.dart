
import 'package:flutter/widgets.dart';
import 'package:animations/animations.dart';

class ClosedAlwaysWrapper{

  const ClosedAlwaysWrapper({
    required this.closedWidget,
    required this.openWidget,
    required this.limitOpenWidgetHeight,
  });

  final Widget closedWidget;
  final Widget openWidget;
  final double limitOpenWidgetHeight;

  OpenContainerBuilder getNoActionClosedBuilder(){
    return (context, action) => closedWidget;
  }
  
  OpenContainerBuilder getNoActionOpenBuilder(){
    return (context, action) => getClosedAlwaysWidget();
  }

  Widget getClosedAlwaysWidget(){
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        children: <Widget> [
          closedWidget,
          Container(
            height: limitOpenWidgetHeight,
            child: openWidget,
          ),
        ],
      ),
    );
  }

}