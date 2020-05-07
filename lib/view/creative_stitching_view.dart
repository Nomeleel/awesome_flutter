import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreativeStitchingView extends StatefulWidget {
  CreativeStitchingView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {
  
  List<Image> _imageList = List<Image>();

  @override
  Widget build(BuildContext context) {
    var defText = (text) => Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        decoration: TextDecoration.none,
      )
    );
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[ 
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: _imageList.length == 0 ? 
              defText('Please click this button') :
              Container(
                padding: EdgeInsets.zero,
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child:GridView.count(
                  crossAxisCount: 3,
                  children: _imageList,
                ),
              ),
          ),
          RaisedButton(
            onPressed: () async {
              await creativeStitching();
            },
            child: defText('Go'),
          ),
          RaisedButton(
            onPressed: () async {
              setState(() {});
            },
            child: defText('Show'),
          ),
        ],
      ),
    );
  }

  creativeStitching() async {
    ByteData imageByteData = await rootBundle.load('assets/images/SaoSiMing.jpg');
    ui.Image image = await decodeImageFromList(imageByteData.buffer.asUint8List());
    var dst = Rect.fromLTWH(0, image.height.toDouble(), image.width.toDouble(), image.width.toDouble());
    var getStitchingImage = (src) async {
      var pictureRecorder = ui.PictureRecorder();
      var paint = Paint();
      paint.isAntiAlias = true;
      var canvas = Canvas(pictureRecorder);
      canvas.drawImageRect(image, src, dst, paint);
      var pic = pictureRecorder.endRecording();
      ui.Image img = await pic.toImage(image.width, image.height * 2 + image.width);
      var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return Image.memory(
        byteData.buffer.asUint8List(),
        fit: BoxFit.cover,
      );
    };

    List<Rect> rectList = getAverageSplitRectList(Rect.fromLTWH(0, 100, image.width.toDouble(), image.width.toDouble()), 3, 3);
    
    rectList.forEach((item) async {
      print(item);
      _imageList.add(await getStitchingImage(item));
    });

  }
  
  List<Rect> getAverageSplitRectList(Rect rect, int rowCount, int colCount) {
    Size cellSize = Size(rect.width / colCount, rect.height / rowCount);
    List<Rect> rectList = List<Rect>();
    for (double i = 0; i < rowCount; i++) {
      for (double j = 0; j < colCount; j++) {
        rectList.add(Rect.fromLTWH(rect.left + j * cellSize.width, rect.top + i * cellSize.height, cellSize.width, cellSize.height));
      }
    }

    return rectList;
  }

}