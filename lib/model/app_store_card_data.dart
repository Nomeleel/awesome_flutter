import 'dart:convert';

import '../template/app_store_card_description.dart';

class AppStoreCardData {
  const AppStoreCardData({
    this.imagePath,
    this.videoPath,
    this.descriptionMode,
    this.descriptionData,
    this.detailViewRouteName,
  });

  AppStoreCardData.fromMap(Map<String, dynamic> jsonData)
      : imagePath = jsonData['imagePath'],
        videoPath = jsonData['videoPath'],
        descriptionMode = AppStoreCardDescriptionMode.values
            .firstWhere((item) => item.toString().endsWith(jsonData['descriptionMode'])),
        descriptionData = AppStoreCardDescriptionData.fromMap(jsonData['descriptionData']),
        detailViewRouteName = jsonData['detailViewRouteName'];

  AppStoreCardData.fromJson(String jsonData) : this.fromMap(json.decode(jsonData));

  AppStoreCardData.simple(String name)
      : imagePath = '',
        videoPath = '',
        descriptionMode = AppStoreCardDescriptionMode.simple,
        descriptionData = AppStoreCardDescriptionData.simple(name),
        detailViewRouteName = name;

  final String imagePath;
  final String videoPath;
  final AppStoreCardDescriptionMode descriptionMode;
  final AppStoreCardDescriptionData descriptionData;
  final String detailViewRouteName;
}
