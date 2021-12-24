import 'package:flutter/widgets.dart';

import '../widget/scaffold_view.dart';
import '../widget/tab_view.dart';

class ImageInQuicklyScrollView extends StatelessWidget {
  const ImageInQuicklyScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Image In Quickly Scroll View',
      body: TabView(
        tabs: ['Image'],
        children: [
          // 模拟目前默认Scroll View中快速滚动时图片的行为
          getListView(Image.network(
            '',
            frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              return Placeholder();
            },
          )),
        ],
      ),
    );
  }

  ListView getListView(Widget item) {
    // 一组图片地址
    final children = List.generate(777, (index) => item);
    return ListView.builder(
      cacheExtent: 0.0,
      itemCount: 777,
      itemBuilder: (BuildContext context, int index) {
        print('build: $index');
        return Stack(
          children: [
            children[index],
            Text('$index'),
          ],
        );
      },
    );
  }
}
