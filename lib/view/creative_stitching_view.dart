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
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[ 
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: _imageList.length == 0 ? 
                defText('Please click this button') :
                AspectRatio(
                  aspectRatio: 1.0,
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    children: _imageList,
                  ),
                ),
            ),
            RaisedButton(
              onPressed: () async {
                await creativeStitching();
                setState(() {});
              },
              child: defText('Go'),
            ),
          ],
        ),
      ),
    );
  }

  creativeStitching() async {
    ByteData imageByteData = await rootBundle.load('assets/images/SaoSiMing.jpg');
    ui.Image image = await decodeImageFromList(imageByteData.buffer.asUint8List());
    var dst = Rect.fromLTWH(0, image.height.toDouble(), image.width.toDouble(), image.width.toDouble());
    var paint = Paint()..isAntiAlias = true;
    
    var getStitchingImage = (src) async {
      var pictureRecorder = ui.PictureRecorder();
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
    
    // for (var rect in rectList)
    //   _imageList.add(await getStitchingImage(rect));
    // The effect is similar to the for loop, because forEach does not support await, 
    // so the following logic is required to be able to sync.
    await Future.wait(rectList.map((item) async {
      _imageList.add(await getStitchingImage(item));
    }));

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