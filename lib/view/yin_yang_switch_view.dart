import 'package:flutter/material.dart';

import '../custom/animation/rolling_transition.dart';
import '../custom/clipper/magatama_clipper.dart';


class YinYangSwitchView extends StatefulWidget {
  @override
  YinYangSwitchViewState createState() => YinYangSwitchViewState();
}

class YinYangSwitchViewState extends State<YinYangSwitchView> with TickerProviderStateMixin {
  // TODO size关联设置
  AnimationController controller;
  Color color;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    Animation<Color> animation = ColorTween(begin: Colors.white, end: Colors.black).animate(controller);
    controller.addListener((){
      setState(() => color = animation.value);
    });
    color = Colors.white;

    super.initState();
  }

  // TODO 解决初始居中的问题 
  @override
  Widget build(BuildContext context){
    return Container(
      color: color,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (controller.status == AnimationStatus.completed) {
              controller.reverse();
            } else if (controller.status == AnimationStatus.dismissed) {
              controller.forward();
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    width: 5,
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: RollingTransition(
                  alignment: Alignment.center,
                  turns: Tween(
                    begin: 0.0,
                    end: 0.5,
                  ).animate(controller),
                  child: Container(
                    alignment: Alignment.center,
                    width: 90,
                    height: 90,
                    color: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          child: Container(
                            color: Colors.white,
                          ),
                          clipper: MagatamaClipper(true),
                        ),
                        Positioned(
                          left: 37.5,
                          top: 15,
                          child: ClipOval(
                            child: Container(
                              width: 15,
                              height: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ClipPath(
                          child: Container(
                            color: Colors.black,
                          ),
                          clipper: MagatamaClipper(false),
                        ),
                        Positioned(
                          left: 37.5,
                          top: 60,
                          child: ClipOval(
                            child: Container(
                              width: 15,
                              height: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
