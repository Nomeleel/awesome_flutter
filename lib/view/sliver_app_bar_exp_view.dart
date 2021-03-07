import 'package:flutter/material.dart';

import '../widget/colorful_list_view.dart';
import '../widget/sliver_app_bar_exp.dart';

class SliverAppBarExpView extends StatelessWidget {
  const SliverAppBarExpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBarExp(
              expandedHeight: 430,
              pinned: true,
              leading: popWidget(
                context,
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              pinnedLeading: popWidget(
                context,
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Text(
                'Rick And Morty',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              pinnedTitle: Text(
                'Rick And Morty',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              brightness: Brightness.dark,
              pinnedChangeBrightness: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color(0xFF030208),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/RickAndMorty.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: const ColorfulListView(
          itemTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget popWidget(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
