import 'package:awesome_flutter/widget/sliver_app_bar_exp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SliverAppBarExpView extends StatelessWidget {
  const SliverAppBarExpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBarExp(
            expandedHeight: 240,
            pinned: true,
            leading: Icon(
              Icons.arrow_back_ios,
              color: Colors.purple,
            ),
            pinnedLeading: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            title: Text(
              '少司命',
              style: TextStyle(
                color: Colors.purple,
              ),
            ),
            pinnedTitle: Text(
              '少司命',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.purple[300],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/SaoSiMing.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 77,
              color: Colors.primaries[index % Colors.primaries.length],
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
            );
          },
          itemCount: 77,
        ),
      ),
    );
  }
}
