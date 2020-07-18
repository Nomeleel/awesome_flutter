import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppStoreCardDescription extends StatelessWidget {
  const AppStoreCardDescription({
    Key key,
    this.mode = AppStoreCardDescriptionMode.classic,
    this.data,
  }) : super(key: key);

  final AppStoreCardDescriptionMode mode;
  final AppStoreCardDescriptionData data;

  @override
  Widget build(BuildContext context) {
    Widget description;

    switch (mode) {
      case AppStoreCardDescriptionMode.classic:
      default:
        description = getClassicDescription();
    }

    return description;
  }

  Widget getClassicDescription() {
    var subText = (text) => Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.grey[500],
            fontSize: 13,
          ),
        );

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          subText(data.label ?? ''),
          Text(
            data.title ?? '',
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.black,
              fontSize: 27,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          subText(data.info ?? ''),
        ],
      ),
    );
  }
}

enum AppStoreCardDescriptionMode {
  /* Classic Mode
    ————————————————————————————————
    | label                        |
    | TitleTitleTitleTitleTitle    |
    | Title                        |
    |                              |
    |                              |
    |                              |
    |                              |
    |                              |
    | info                         |
    ————————————————————————————————
  */
  classic,
}

class AppStoreCardDescriptionData {
  const AppStoreCardDescriptionData({
    this.label,
    this.title,
    this.info,
  });

  AppStoreCardDescriptionData.fromMap(Map<String, dynamic> dataMap)
      : label = dataMap['label'],
        title = dataMap['title'],
        info = dataMap['info'];

  AppStoreCardDescriptionData.fromJson(String jsonData)
      : this.fromMap(json.decode(jsonData));

  final String title;
  final String label;
  final String info;
}
