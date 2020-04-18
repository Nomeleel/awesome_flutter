import 'package:flutter/material.dart';

import 'custom/clipper/waveRectClipper.dart';

class WaterWaveView extends StatefulWidget {
  @override
  WaterWaveViewState createState() => WaterWaveViewState();
}

class WaterWaveViewState extends State<WaterWaveView> with TickerProviderStateMixin {
  double waterContainerHeight = 500;
  double get waterContainerWidth => waterContainerHeight * 0.618 * 0.618;
  Color get fullColor{
    if (currentWaterHeight < fullWaterHeight * 0.3)
      return Colors.red;
    else if (currentWaterHeight < fullWaterHeight * 0.6)
      return Colors.purple;
    else if (currentWaterHeight < fullWaterHeight)
      return Colors.green;
    else
      return Colors.white;
  }
  double fullWaterHeight = 2000;
  double currentWaterHeight = 600;
  double get unit => fullWaterHeight / waterContainerHeight;
  double get remainHeight => (fullWaterHeight - animation.value) / unit;
  double updateWaterUnitHeight = 200;

  AnimationController loopAnimationController;
  AnimationController adjustWaterHeightController;

  Animation curve;
  Animation animation;

  @override
  void initState() {
    const Duration duration = Duration(milliseconds: 2000);

    // loopAnimationController
    loopAnimationController = AnimationController(duration: duration, vsync: this,)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          loopAnimationController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          loopAnimationController.forward();
        }
      })
      ..forward();

    // adjustWaterHeightController
    adjustWaterHeightController = AnimationController(duration: duration, vsync: this,);
    curve = CurvedAnimation(parent: adjustWaterHeightController, curve: Curves.easeInOut,);
    setAnimation(currentWaterHeight)
      ..addListener(() => currentWaterHeight = animation.value)
      ..forward();

    super.initState();
  }

  AnimationController setAnimation(double newValue){
    animation = Tween<double>(
        begin: (newValue == currentWaterHeight) ? 0 : currentWaterHeight,
        end: (newValue < 0) ? 0 : newValue,
      ).animate(curve);

    return adjustWaterHeightController..repeat();
  }

  @override
  void dispose() {
    loopAnimationController.dispose();
    adjustWaterHeightController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          SizedBox(
            // TODO 位置居中调整
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Icon(
                    Icons.add,
                    color: fullColor,
                    size: 24,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setAnimation(currentWaterHeight + updateWaterUnitHeight)
                      ..forward();
                  },
                ),
//                Container(
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    shape: BoxShape.circle,
//                    boxShadow: <BoxShadow>[
//                      BoxShadow(
//                          color: fullColor.withOpacity(0.4),
//                          offset: Offset(4.0, 4.0),
//                          blurRadius: 8.0),
//                    ],
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.all(6.0),
//                    child: Icon(
//                      Icons.remove,
//                      color: fullColor,
//                      size: 24,
//                    ),
//                  ),
//                ),
                SizedBox(
                  height: 28,
                ),
                RaisedButton(
                  child: Icon(
                    Icons.remove,
                    color: fullColor,
                    size: 24,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setAnimation(currentWaterHeight - updateWaterUnitHeight)
                      ..forward();
                  },
                ),
              ],
            ),
          ),
          Container(
            width: waterContainerWidth,
            height: waterContainerHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(waterContainerWidth / 2),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.9),
                    offset: Offset(2, 2),
                    blurRadius: 4,
                ),
              ],
            ),
            child: Container (
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(waterContainerWidth / 2),
                ),
              ),
              child: AnimatedBuilder(
                  animation: CurvedAnimation(
                    parent: loopAnimationController,
                    curve: Curves.easeInOut,
                  ),
                  builder: (context, child) => Stack(
                    children: <Widget>[
                      ClipPath(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: fullColor.withOpacity(0.618),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(waterContainerWidth / 2),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    fullColor.withOpacity(0.2),
                                    fullColor.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        clipper: WaveRectClipper(loopAnimationController.value, Offset(0, remainHeight)),
                      ),
                      ClipPath(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: fullColor,
                                gradient: LinearGradient(
                                  colors: [
                                    fullColor.withOpacity(0.4),
                                    fullColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(waterContainerWidth / 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        clipper: WaveRectClipper(loopAnimationController.value, Offset(waterContainerWidth, remainHeight)),
                      ),
                      Center(
                        child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                // TODO 是否有版权
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                                letterSpacing: 0.0,
                                color: Colors.green,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: (animation.value / fullWaterHeight * 100).toInt().toString()),
                                TextSpan(text: "%"),
                              ],
                            ),
                          ),
                      ),
                      Positioned(
                        top: 0,
                        left: 6,
                        bottom: 8,
                        child: ScaleTransition(
                          alignment: Alignment.center,
                          scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                              parent: loopAnimationController,
                              curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn))),
                          child: Container(
                            width: 2,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 0,
                        bottom: 16,
                        child: ScaleTransition(
                          alignment: Alignment.center,
                          scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                              parent: loopAnimationController,
                              curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn))),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 24,
                        bottom: 32,
                        child: ScaleTransition(
                          alignment: Alignment.center,
                          scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                              parent: loopAnimationController,
                              curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn))),
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 20,
                        bottom: 0,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 16 * (1.0 - loopAnimationController.value), 0.0),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                  loopAnimationController.status == AnimationStatus.reverse
                                      ? 0.0
                                      : 0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset("assets/images/bottle.png"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}

