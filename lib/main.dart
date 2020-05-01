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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: viewRoutes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  _MyHomePageState();

  List<AppStoreCardData> _cardDataList = List<AppStoreCardData>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    String jsonData = await rootBundle.loadString('assets/data/CardDataList.json');
    if (jsonData != null && jsonData != '') {
      (json.decode(jsonData)['cardDataList'] as List).forEach((item) {
        _cardDataList.add(AppStoreCardData.fromMap(item));
      });
      
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: _cardDataList.length == 0 ? 
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ) :
          ListView.builder(
            itemCount: _cardDataList.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => appStoreCardItem(context, _cardDataList[index]),
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