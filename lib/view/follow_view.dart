import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FollowView extends StatelessWidget {
  const FollowView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
      initialPage: 7,
      viewportFraction: 0.7,
    );
    controller.addListener(() {});
    return ScaffoldView(
      title: 'Follow View',
      body: Column(
        children: [
          Container(
            height: 200.0,
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  // 0 < controller.page < pageSize 但是两端溢出值我还是要的
                  angle: controller.hasClients ? -controller.offset / 500 : controller.initialPage.toDouble(),
                  child: child,
                );
              },
              child: Container(
                height: 77.0,
                width: 77.0,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  '|',
                  style: TextStyle(fontSize: 77.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              itemCount: 77,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
