import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef DecodeImageProvider = Future<ui.Image> Function(dynamic image);

Future<List<ByteData>> creativeStitchingByAsset(
  String mainAsset,
  List<String> multipleAssetsList, {
  Rect? mainImageCropRect,
  int rowCount = 3,
  int colCount = 3,
}) async {
  DecodeImageProvider decodeImageProvider = (assetKey) async =>
      await decodeImageFromList(
          (await rootBundle.load(assetKey)).buffer.asUint8List());

  return _creativeStitching(decodeImageProvider, mainAsset, multipleAssetsList,
      mainImageCropRect, rowCount, colCount);
}

Future<List<ByteData>> creativeStitchingByFile(
  File mainImageFile,
  List<File> multipleImageList, {
  Rect? mainImageCropRect,
  int rowCount = 3,
  int colCount = 3,
}) async {
  DecodeImageProvider decodeImageProvider =
      (file) async => await decodeImageFromList(await file.readAsBytes());

  return _creativeStitching(decodeImageProvider, mainImageFile,
      multipleImageList, mainImageCropRect, rowCount, colCount);
}

Future<List<ByteData>> creativeStitchingByFilePath(
  String mainImageFilePath,
  List<String> multipleImagePathList, {
  Rect? mainImageCropRect,
  int rowCount = 3,
  int colCount = 3,
}) async {
  DecodeImageProvider decodeImageProvider = (filePath) async =>
      await decodeImageFromList(await File(filePath).readAsBytes());

  return _creativeStitching(decodeImageProvider, mainImageFilePath,
      multipleImagePathList, mainImageCropRect, rowCount, colCount);
}

Future<List<ByteData>> _creativeStitching(
    DecodeImageProvider decodeImageProvider,
    dynamic mainImageFile,
    List<dynamic> multipleImageList,
    Rect? mainImageCropRect,
    int rowCount,
    int colCount) async {
  List<ByteData> byteDataList = <ByteData>[];

  // TODO(Nomeleel): Image size should be limited.
  ui.Image mainImage = await decodeImageProvider(mainImageFile);
  List<Rect> rectList = _getAverageSplitRectList(
      mainImageCropRect ?? _getDefaultCropRect(mainImage), rowCount, colCount);
  var paint = Paint()..isAntiAlias = true;

  var getStitchingImage =
      (int cropCellIndex, int finalImageIndex, bool isRepeat) async {
    ui.Image topImage =
        await decodeImageProvider(multipleImageList[finalImageIndex]);
    ui.Image bottomImage = isRepeat
        ? topImage
        : await decodeImageProvider(multipleImageList[finalImageIndex + 1]);

    var pictureRecorder = ui.PictureRecorder();
    var canvas = Canvas(pictureRecorder);

    // TODO(Nomeleel): Find root cause.
    /*
      1. Images cannot be over-scaled.
      2. Here should take minimum value.
      3. Tried to minify the width three times, no crash.
      4. Find a balance between minify and picture quality.
    */
    // For commint 3 do this update, now is work, but should research accurate value.
    int width = math.max(topImage.width, bottomImage.width) ~/ 3;
    int resetTopHeight = (width / topImage.width * topImage.height).toInt();
    int resetBottomHeight =
        (width / bottomImage.width * bottomImage.height).toInt();
    int resetHeight = math.max(resetTopHeight, resetBottomHeight);
    int height = resetHeight * 2 + width;

    canvas.drawImageRect(
        topImage,
        Rect.fromLTWH(
            0, 0, topImage.width.toDouble(), topImage.height.toDouble()),
        Rect.fromLTWH(0, 0, width.toDouble(), resetTopHeight.toDouble()),
        paint);
    canvas.drawImageRect(
        mainImage,
        rectList[cropCellIndex],
        Rect.fromLTWH(
            0, resetHeight.toDouble(), width.toDouble(), width.toDouble()),
        paint);
    canvas.drawImageRect(
        bottomImage,
        Rect.fromLTWH(
            0, 0, bottomImage.width.toDouble(), bottomImage.height.toDouble()),
        Rect.fromLTWH(0, (height - resetBottomHeight).toDouble(),
            width.toDouble(), resetBottomHeight.toDouble()),
        paint);

    ui.Image finalImage =
        await pictureRecorder.endRecording().toImage(width, height);

    topImage.dispose();
    if (!isRepeat) {
      bottomImage.dispose();
    }

    return await finalImage.toByteData(format: ui.ImageByteFormat.png);
  };

  int maxCount = rowCount * colCount;
  int doubleImageCount =
      math.min(math.max(0, multipleImageList.length - maxCount), maxCount);
  int finalCount =
      math.min(multipleImageList.length - doubleImageCount, maxCount);

  for (int i = 0, index = 0; i < finalCount; i++) {
    bool isRepeat = doubleImageCount-- <= 0;
    byteDataList.add((await getStitchingImage(i, index, isRepeat))!);
    index += isRepeat ? 1 : 2;
  }

  return byteDataList;
}

Rect _getDefaultCropRect(ui.Image image) {
  double min = math.min(image.height, image.width).toDouble();
  return Rect.fromLTWH(
      (image.width - min) / 2, (image.height - min) / 2, min, min);
}

List<Rect> _getAverageSplitRectList(Rect rect, int rowCount, int colCount) {
  double length = rect.width / math.max(rowCount, colCount);
  List<Rect> rectList = <Rect>[];
  for (double i = 0; i < rowCount; i++) {
    for (double j = 0; j < colCount; j++) {
      rectList.add(Rect.fromLTWH(
          rect.left + j * length, rect.top + i * length, length, length));
    }
  }

  return rectList;
}
