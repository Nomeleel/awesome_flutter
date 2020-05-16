import 'dart:io';
import 'dart:math' as math;
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
                File mainImageFile = File('/storage/emulated/0/Download/SaoSiMing.jpg');
                List<File> multipleImageList = List.generate(15, (index) => 
                  File('/storage/emulated/0/Download/heng${math.Random().nextInt(7)}.jpg'))
                  ..add(File('/storage/emulated/0/Download/shu.jpg'))
                  ..add(File('/storage/emulated/0/Download/shu.jpg'));
                creativeStitching(mainImageFile, multipleImageList).then((byteDataList) {
                  setState(() {
                    byteDataList.forEach((byteData) {
                      _imageList.add(Image.memory(
                        byteData.buffer.asUint8List(),
                        fit: BoxFit.cover,
                      ));
                    });
                  });
                });
              },
              child: defText('Go'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ByteData>> creativeStitching(File mainImageFile, List<File> multipleImageList, {
    Rect mainImageCropRect,
    int rowCount = 3,
    int colCount = 3,
  }) async {
    List<ByteData> byteDataList = List<ByteData>();

    ui.Image mainImage = await decodeImageByFile(mainImageFile);
    List<Rect> rectList = getAverageSplitRectList(mainImageCropRect ?? getDefaultCropRect(mainImage), rowCount, colCount);
    var paint = Paint()..isAntiAlias = true;
    
    var getStitchingImage = (int cropCellIndex, int finalImageIndex, bool isRepeat) async {
      ui.Image topImage = await decodeImageByFile(multipleImageList[finalImageIndex]);
      ui.Image bottomImage = isRepeat ? topImage :
        await decodeImageByFile(multipleImageList[finalImageIndex + 1]);

      var pictureRecorder = ui.PictureRecorder();
      var canvas = Canvas(pictureRecorder);

      int width = math.max(topImage.width, bottomImage.width);
      int resetTopHeight = (width / topImage.width * topImage.height).toInt();
      int resetBottomHeight = (width / bottomImage.width * bottomImage.height).toInt();
      int resetHeight = math.max(resetTopHeight, resetBottomHeight);
      int height = resetHeight * 2 + width;

      canvas.drawImageRect(topImage, Rect.fromLTWH(0, 0, topImage.width.toDouble(), 
        topImage.height.toDouble()), Rect.fromLTWH(0, 0, width.toDouble(), resetTopHeight.toDouble()), paint);
      canvas.drawImageRect(mainImage, rectList[cropCellIndex],
        Rect.fromLTWH(0, resetHeight.toDouble(), width.toDouble(), width.toDouble()), paint);
      canvas.drawImageRect(bottomImage, Rect.fromLTWH(0, 0, bottomImage.width.toDouble(), bottomImage.height.toDouble()), 
        Rect.fromLTWH(0, (height - resetBottomHeight).toDouble(), width.toDouble(), resetBottomHeight.toDouble()), paint);

      ui.Image finalImage = await pictureRecorder.endRecording().toImage(width, height);
      
      return await finalImage.toByteData(format: ui.ImageByteFormat.png);
    };

    int maxCount = rowCount * colCount;
    int doubleImageCount = math.min(math.max(0, multipleImageList.length - maxCount), maxCount);
    int finalCount = math.min(multipleImageList.length - doubleImageCount, maxCount);

    // for (var rect in rectList)
    //   _imageList.add(await getStitchingImage(rect));
    // The effect is similar to the for loop, because forEach does not support await, 
    // so the following logic is required to be able to sync.
    /*
      await Future.wait(list.map((item) async {
        await getStitchingImage(item, true);
      }));
    */

    for(int i = 0, index = 0; i < finalCount; i++) {
      bool isRepeat = doubleImageCount-- <= 0;
      byteDataList.add(await getStitchingImage(i, index, isRepeat));
      index += isRepeat ? 1 : 2;
    } 

    return byteDataList;
  }
  
  Future<ui.Image> decodeImageByFile(File file) async {
    return await decodeImageFromList(await file.readAsBytes());
  }

  Rect getDefaultCropRect(ui.Image image) {
    double min = math.min(image.height, image.width).toDouble();
    return Rect.fromLTWH((image.width - min) / 2, (image.height - min) / 2, min, min);
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