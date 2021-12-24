import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as image;

typedef DecodeImageProvider = Future<image.Image> Function(dynamic image);

Future<List<File>> creativeStitchingByFile(
  File mainImageFile,
  List<File> multipleImageList, {
  Rect? mainImageCropRect,
  int rowCount = 3,
  int colCount = 3,
}) async {
  DecodeImageProvider decodeImageProvider = (file) async => image.decodeImage(await file.readAsBytes())!;

  return _creativeStitching(
      decodeImageProvider, mainImageFile, multipleImageList, mainImageCropRect, rowCount, colCount);
}

Future<List<File>> creativeStitchingByFilePath(
  String mainImageFilePath,
  List<String> multipleImagePathList, {
  Rect? mainImageCropRect,
  int rowCount = 3,
  int colCount = 3,
}) async {
  DecodeImageProvider decodeImageProvider = (filePath) async {
    var bytes = await File(filePath).readAsBytes();
    return image.decodeImage(bytes)!;
  };

  return _creativeStitching(
      decodeImageProvider, mainImageFilePath, multipleImagePathList, mainImageCropRect, rowCount, colCount);
}

Future<List<File>> _creativeStitching(DecodeImageProvider decodeImageProvider, dynamic mainImageFile,
    List multipleImageList, Rect? mainImageCropRect, int rowCount, int colCount) async {
  List<File> byteDataList = <File>[];

  String targetFilePath = '/data/user/0/com.example.isolate_test/cache/test2.jpg';

  // TODO(Nomeleel): Image size should be limited.
  image.Image mainImage = await decodeImageProvider(mainImageFile);
  mainImageCropRect ??= _getDefaultCropRect(mainImage);
  List<Rect> rectList = _getAverageSplitRectList(mainImageCropRect, rowCount, colCount);

  int maxCount = rowCount * colCount;
  int doubleImageCount = math.min(math.max(0, multipleImageList.length - maxCount), maxCount);
  int finalCount = math.min(multipleImageList.length - doubleImageCount, maxCount);

  for (int i = 0, index = 0; i < finalCount; i++) {
    bool isRepeat = doubleImageCount-- <= 0;
    byteDataList.add(await compute(
        getStitchingImageCompute, [mainImage, multipleImageList, i, rectList[i], index, isRepeat, targetFilePath]));
    index += isRepeat ? 1 : 2;
  }

  return byteDataList;
}

Future<File> getStitchingImageCompute(List param) {
  return Function.apply(getStitchingImage, param);
}

Future<File> getStitchingImage(
  //DecodeImageProvider decodeImageProvider,
  image.Image mainImage,
  List multipleImageList,
  int cropCellIndex,
  Rect mainIndexRect,
  int finalImageIndex,
  bool isRepeat,
  String targetFilePath,
) async {
  DecodeImageProvider decodeImageProvider = (filePath) async {
    var bytes = await File(filePath).readAsBytes();
    return image.decodeImage(bytes)!;
  };

  image.Image topImage = await decodeImageProvider(multipleImageList[finalImageIndex]);
  print(topImage.width);
  print(topImage.height);
  image.Image bottomImage = isRepeat ? topImage : await decodeImageProvider(multipleImageList[finalImageIndex + 1]);
  print(bottomImage.width);
  print(bottomImage.height);
  int width = math.max(topImage.width, bottomImage.width);
  int resetTopHeight = (width / topImage.width * topImage.height).toInt();
  int resetBottomHeight = (width / bottomImage.width * bottomImage.height).toInt();
  int resetHeight = math.max(resetTopHeight, resetBottomHeight);
  int height = resetHeight * 2 + width;

  image.Image finalImage = image.Image(width, height)..fill(0xFFFFFFFF);

  image.drawImage(
    finalImage,
    topImage,
    dstW: width,
    dstH: resetTopHeight,
  );

  image.drawImage(
    finalImage,
    mainImage,
    dstY: resetHeight,
    dstW: width,
    dstH: width,
    srcX: mainIndexRect.left.toInt(),
    srcY: mainIndexRect.top.toInt(),
    srcW: mainIndexRect.width.toInt(),
    srcH: mainIndexRect.height.toInt(),
  );

  image.drawImage(
    finalImage,
    bottomImage,
    dstY: height - resetBottomHeight,
    dstW: width,
    dstH: resetBottomHeight,
  );

  File file = File(targetFilePath.replaceFirst('2', '$cropCellIndex$cropCellIndex'));

  await file.writeAsBytes(image.encodeJpg(finalImage));

  return file;
}

Rect _getDefaultCropRect(image.Image image) {
  double min = math.min(image.height, image.width).toDouble();
  return Rect.fromLTWH((image.width - min) / 2, (image.height - min) / 2, min, min);
}

List<Rect> _getAverageSplitRectList(Rect rect, int rowCount, int colCount) {
  double length = rect.width / math.max(rowCount, colCount);
  List<Rect> rectList = <Rect>[];
  for (double i = 0; i < rowCount; i++) {
    for (double j = 0; j < colCount; j++) {
      rectList.add(Rect.fromLTWH(rect.left + j * length, rect.top + i * length, length, length));
    }
  }

  return rectList;
}
