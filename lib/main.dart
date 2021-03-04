import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'layout/layout.dart';
import 'model/app_store_card_data.dart';
import 'route/view_routes.dart';
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
      home: Layout(
        child: const MyHomePage(),
      ),
      routes: viewRoutes,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          final pageName = kIsWeb ? settings.name.substring(1) : settings.name;
          return Layout(
            child: viewRoutes.containsKey(pageName) ? viewRoutes[pageName](context) : const MyHomePage(),
          );
        });
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

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

  getData() {
    rootBundle.loadString('assets/data/CardDataList.json').then(
      (value) {
        if (value?.isNotEmpty ?? false) {
          json.decode(value)['cardDataList']?.forEach((item) {
            _cardDataList.add(AppStoreCardData.fromMap(item));
          });

          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: _cardDataList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : ListView.builder(
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
