import 'package:awesome_flutter/util/math_util.dart';
import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class MaterialTestView extends StatelessWidget {
  const MaterialTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Material Test View',
      body: Wrap(
        children: [
          Material(
            color: _color(),
            elevation: 22.0,
            shadowColor: _color(),
            shape: _stadiumBorder(),
            child: _container(),
          ),
          Material(
            color: _color(),
            elevation: 10.0,
            shadowColor: _color(),
            shape: _roundedRectangleBorder(),
            child: _container(),
          ),
          Material(
            type: MaterialType.transparency,
            color: _color(),
            elevation: 10.0,
            shadowColor: _color(),
            shape: _roundedRectangleBorder(),
            child: _container(),
          ),
          Material(
            color: _color(),
            elevation: 10.0,
            shadowColor: _color(),
            shape: _stadiumBorder(),
            child: _container(),
          ),
          Material(
            color: _color(),
            borderOnForeground: false,
            elevation: 10.0,
            shadowColor: _color(),
            shape: _stadiumBorder(),
            child: _container(),
          ),
          Material(
            color: _color(),
            borderOnForeground: false,
            clipBehavior: Clip.antiAlias,
            elevation: 10.0,
            shadowColor: _color(),
            shape: _stadiumBorder(),
            child: _container(),
          ),
          Material(
            color: _color(),
            clipBehavior: Clip.antiAlias,
            elevation: 10.0,
            shadowColor: _color(),
            shape: _stadiumBorder(),
            child: _container(),
          ),
        ],
      ),
    );
  }

  Container _container() {
    return Container(
      height: 100.0,
      width: 150.0,
      child: Text('国', style: TextStyle(fontSize: 50.0),),
    );
  }

  Color _color() => Colors.primaries[randomInt(0, Colors.primaries.length)];

  BorderSide _borderSide() {
    return BorderSide(
      width: 5,
      color: _color(),
    );
  }

  BorderRadius _borderRadius() => BorderRadius.all(Radius.circular(20.0));

  StadiumBorder _stadiumBorder() {
    return StadiumBorder(
      side: _borderSide(),
    );
  }

  RoundedRectangleBorder _roundedRectangleBorder() {
    return RoundedRectangleBorder(
      borderRadius: _borderRadius(),
      side: _borderSide(),
    );
  }
}
