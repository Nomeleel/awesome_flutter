import 'package:awesome_flutter/widget/colorful_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/scaffold_view.dart';

class RefreshIndicatorTestView extends StatefulWidget {
  const RefreshIndicatorTestView({Key key}) : super(key: key);

  @override
  _RefreshIndicatorTestViewState createState() => _RefreshIndicatorTestViewState();
}

class _RefreshIndicatorTestViewState extends State<RefreshIndicatorTestView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Refresh Indicator Test View',
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(Duration(seconds: 1));
        },
        child: ColorfulListView(),
      ),
    );
  }
}
