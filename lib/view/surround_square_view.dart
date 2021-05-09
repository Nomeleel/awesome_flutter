import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/scaffold_view.dart';

//TODO 后期将用RenderObject实现。
//TODO 嵌套循环的方式可以当成加载动画来实现(下次一定)
class SurroundSquareView extends StatefulWidget {
  const SurroundSquareView({Key key}) : super(key: key);

  @override
  _SurroundSquareViewState createState() => _SurroundSquareViewState();
}

class _SurroundSquareViewState extends State<SurroundSquareView> with SingleTickerProviderStateMixin {
  final Duration duration = Duration(milliseconds: 2000);
  final double min = 0.01;
  final double max = 20.0;

  double childAspectRatio;
  List<Widget> children;

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    reset();

    animationController = AnimationController(
      lowerBound: min,
      upperBound: max,
      duration: duration,
      vsync: this,
    )..drive(CurveTween(curve: Curves.slowMiddle));

    animationController.addListener(() {
      setState(() {
        childAspectRatio = animationController.value;
      });
    });
  }

  void reset() {
    childAspectRatio = math.Random().nextDouble() * (max - min) + min;
    children = List.generate(math.Random().nextInt(7) + 3, getRandomItem);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Surround Square View',
      action: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            reset();
          });
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          surroundSquare(),
          Text(
            'Children Count: ${children.length}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            'Child Aspect Ratio: $childAspectRatio',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp),
                onPressed: () {
                  setState(() {
                    children.insert(0, children.removeLast());
                  });
                },
              ),
              IconButton(
                icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: animationController),
                onPressed: () {
                  if (animationController.isAnimating)
                    animationController.reset();
                  else
                    animationController.repeat();
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  setState(() {
                    children.add(children.removeAt(0));
                  });
                },
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            child: Slider(
              value: childAspectRatio,
              min: min,
              max: max,
              onChanged: (value) {
                setState(() {
                  childAspectRatio = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget surroundSquare() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: positionedList(MediaQuery.of(context).size.shortestSide),
      ),
    );
  }

  List positionedList(double squareLength, [double offset = 20.0]) {
    squareLength -= offset * 2.0;
    final double unit = squareLength / (childAspectRatio + 1.0).toDouble();
    return positionedSurround(unit, offset)
      ..addAll(positionedCenter(math.min(unit, unit * childAspectRatio) + offset));
  }

  // 正方体可采用旋转 4个item大小相同
  // 实际当成长方形 正方形为长方形的一种特殊情况
  List<Positioned> positionedSurround(double length, [double offset = 0.0]) {
    final double allOffset = length + offset;
    return <Positioned>[
      if (children.length > 0)
        Positioned(
          left: offset,
          right: allOffset,
          top: offset,
          height: length,
          child: children[0],
        ),
      if (children.length > 1)
        Positioned(
          right: offset,
          width: length,
          top: offset,
          bottom: allOffset,
          child: children[1],
        ),
      if (children.length > 2)
        Positioned(
          left: allOffset,
          right: offset,
          bottom: offset,
          height: length,
          child: children[2],
        ),
      if (children.length > 3)
        Positioned(
          left: offset,
          width: length,
          top: allOffset,
          bottom: offset,
          child: children[3],
        ),
    ];
  }

  List<Positioned> positionedCenter([double offset = .0]) {
    final mapPositioned = (Widget e) => Positioned(
          left: offset,
          right: offset,
          top: offset,
          bottom: offset,
          child: e,
        );
    return children.skip(4).map(mapPositioned).toList().reversed.toList();
  }

  Widget getRandomItem(int index) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tap $index.')));
      },
      child: Container(
        // color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        // alignment: Alignment.center,
        // child: Icon(IconData(Random().nextInt(0xfff) + 0xe000, fontFamily: 'MaterialIcons')),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/${math.Random().nextInt(7).isEven ? 'SaoSiMing' : 'BaoErJie'}.jpg',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Text('$index'),
            ),
          ],
        ),
      ),
    );
  }
}
