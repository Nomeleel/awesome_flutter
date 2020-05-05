import 'package:flutter/widgets.dart';

class MultipleImageGridView extends StatefulWidget {
  MultipleImageGridView({Key key}) : super(key: key);

  @override
  _MultipleImageGridViewState createState() => _MultipleImageGridViewState();
}

class _MultipleImageGridViewState extends State<MultipleImageGridView> {
  
  List<Image> _imageList;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
      var assetImage = (name) {
      double length = (MediaQuery.of(context).size.width - 50) / 3;
      return Image.asset(
        name,
        fit: BoxFit.cover,
        width: length,
        height: length,
      );
    };

    _imageList = List<Image>(9);
    _imageList.fillRange(0, 8, assetImage('assets/images/SaoSiMing.jpg'));
    _imageList[8] = assetImage('assets/images/Test1.jpg');

    return Container(
       child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        children: _imageList,
      ),
    );
  }
}