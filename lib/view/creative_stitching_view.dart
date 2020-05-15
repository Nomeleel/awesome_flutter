import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CreativeStitchingView extends StatefulWidget {
  CreativeStitchingView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {
  
  List<Widget> _imageList = List<Widget>();

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
                //await creativeStitching();
                //setState(() {});
              },
              child: defText('Go'),
            ),
          ],
        ),
      ),
    );
  }

  creativeStitching(File mainImageFile, List<File> multipleImageList, {
    Rect mainImageCropRect,
    int rowCount = 3,
    int colCount = 3,
  }) async {
    ui.Image image = await decodeImageFromList(await mainImageFile.readAsBytes());
    var paint = Paint()..isAntiAlias = true;
    
    var getDefaultCropRect = () {
      double min = math.min(image.height, image.width).toDouble();
      return Rect.fromLTWH((image.width - min) / 2, (image.height - min) / 2, min, min);
    };

    var dst = Rect.fromLTWH(0, image.height.toDouble(), image.width.toDouble(), image.width.toDouble());
    
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

    List<Rect> rectList = getAverageSplitRectList(mainImageCropRect ?? getDefaultCropRect(), rowCount, colCount);
    int maxCount = rowCount * colCount;
    int doubleImageCount = math.min(math.max(0, multipleImageList.length - maxCount), maxCount);

    // double image mode
    for(int i = 0; i < doubleImageCount; i++) {

    } 
    
    // repeat image mode
    for(int i = doubleImageCount; i < maxCount; i++) {

    } 

    // for (var rect in rectList)
    //   _imageList.add(await getStitchingImage(rect));
    // The effect is similar to the for loop, because forEach does not support await, 
    // so the following logic is required to be able to sync.
    await Future.wait(rectList.map((item) async {
      _imageList.add(ListView(
        children: <Widget> [
          await getStitchingImage(item),
        ],
      ));
    }));

  }
  
  List<Rect> getAverageSplitRectList(Rect rect, int rowCount, int colCount) {
    double length = rect.width / math.max(rowCount, colCount);
    List<Rect> rectList = List<Rect>();
    for (double i = 0; i < rowCount; i++) {
      for (double j = 0; j < colCount; j++) {
        rectList.add(Rect.fromLTWH(rect.left + j * length, rect.top + i * length, length, length));
      }
    }

    return rectList;
  }

}