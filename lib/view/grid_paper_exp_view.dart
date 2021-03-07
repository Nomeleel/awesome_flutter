import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/grid_paper_exp.dart';

class GridPaperExpView extends StatefulWidget {
  const GridPaperExpView({Key key}) : super(key: key);

  @override
  GridPaperExpViewState createState() => GridPaperExpViewState();
}

class GridPaperExpViewState extends State<GridPaperExpView> {
  double _lineWidth;

  @override
  void initState() {
    _lineWidth = 1.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(''),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridPaperExp(
                strokeWidth: _lineWidth,
                interval: (MediaQuery.of(context).size.width - 20),
                divisions: 3,
                subdivisions: 3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Width: $_lineWidth',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: CupertinoSlider(
              value: _lineWidth,
              min: 0.1,
              max: 200.0,
              activeColor: Colors.purple,
              onChanged: (value) {
                setState(() {
                  _lineWidth = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
