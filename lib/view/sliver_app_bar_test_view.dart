import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/colorful_list_view.dart';

class SliverAppBarTestView extends StatelessWidget {
  const SliverAppBarTestView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: popWidget(
              context,
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: titleWidget(),
            flexibleSpace: FlexibleSpaceBar(
              // title: titleWidget(),
              // centerTitle: true,
              // titlePadding: EdgeInsets.zero,
              background: Container(
                color: Color(0xFF030208),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/RickAndMorty.jpg',
                  fit: BoxFit.cover,
                ),
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.purple,
                      Colors.transparent,
                    ]
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
              stretchModes: StretchMode.values,
            ),
            // bottom: PreferredSize(
            //   preferredSize: Size.fromHeight(30),
            //   child: Container(
            //     alignment: Alignment.center,
            //     child: Text(
            //       'Bottom',
            //       style: Theme.of(context).textTheme.headline6,
            //     ),
            //   ),
            // ),
            elevation: 77.0,
            shadowColor: Colors.purple.withOpacity(.7),
            forceElevated: true,
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            brightness: Brightness.dark,
            collapsedHeight: null,
            expandedHeight: 430,
            floating: false,
            pinned: true,
            snap: false,
            stretch: true,
            stretchTriggerOffset: 50.0,
            onStretchTrigger: () async {
              print('-----load-----');
            },
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          const ColorfulListView(
            itemTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
          ).buildSliver(context),
        ],
      ),
    );
  }

  Widget titleWidget() {
    return Text(
      'Rick And Morty',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
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
