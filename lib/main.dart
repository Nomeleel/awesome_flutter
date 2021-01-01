import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_scan/route/view_routes.dart';

import 'model/app_store_card_data.dart';
import 'template/app_store_card_description.dart';
import 'widget/app_store_card.dart';
import 'wrapper/image_wraper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const MyHomePage(),
      routes: viewRoutes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Future<List<AppStoreCardData>> getHomePageConfig() async {
    List<AppStoreCardData> cardDataList = [];
    String jsonData = await rootBundle.loadString('assets/data/CardDataList.json');
    if (jsonData?.isNotEmpty ?? false) {
      (json.decode(jsonData)['cardDataList'] as List).forEach((item) {
        cardDataList.add(AppStoreCardData.fromMap(item));
      });
    }
    return cardDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<AppStoreCardData>>(
          future: getHomePageConfig(),
          builder: (BuildContext context, AsyncSnapshot<List<AppStoreCardData>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => appStoreCardItem(context, snapshot.data[index]),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget appStoreCardItem(BuildContext context, AppStoreCardData data) {
    return AppStoreCard(
      key: Key(data.hashCode.toString()),
      elevation: 5,
      padding: EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 10,
      ),
      radius: BorderRadius.all(Radius.circular(20)),
      showBackgroundWidget: ImageWraper.path(data.imagePath),
      showForegroundWidget: AppStoreCardDescription(
        mode: data.descriptionMode,
        data: data.descriptionData,
      ),
      detailWidget: viewRoutes[data.detailViewRouteName](context),
    );
  }
}
