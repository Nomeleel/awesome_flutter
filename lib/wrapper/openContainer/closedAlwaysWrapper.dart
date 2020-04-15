
import 'package:flutter/widgets.dart';
import 'package:animations/animations.dart';

class ClosedAlwaysWrapper{

  const ClosedAlwaysWrapper({
    @required this.closedWidget,
    @required this.openWidget,
  });

  final Widget closedWidget;
  final Widget openWidget;

  OpenContainerBuilder getClosedBuilder(){
    return (context, action) => closedWidget;
  }
  
  OpenContainerBuilder getOpenBuilder(){
    // TODO imp
    return (context, action) => openWidget;
  }

}