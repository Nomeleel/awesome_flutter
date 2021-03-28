import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/story_swiper.dart';

class StorySwiperView extends StatefulWidget {
  const StorySwiperView({Key key}) : super(key: key);

  @override
  _StorySwiperViewState createState() => _StorySwiperViewState();
}

class _StorySwiperViewState extends State<StorySwiperView> {
  ValueNotifier<int> index = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Swiper View'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: index,
            builder: (BuildContext context, int value, Widget child) {
              return Text(
                'Index: $value',
                style: Theme.of(context).textTheme.headline5,
              );
            },
          ),
          Container(
            height: 200.0,
            child: StorySwiper.builder(
              itemCount: 10,
              aspectRatio: 0.76,
              depthFactor: 0.2,
              dx: 140,
              dy: 7,
              paddingStart: 15,
              verticalPadding: 5,
              visiblePageCount: 4,
              limitLength: 20,
              onTap: (e) {
                print('-----tap------');
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Tap: $e'),
                  duration: const Duration(milliseconds: 2000),
                ));
              },
              onPageChanged: (e) {
                print('-----page----');
                print(e);
                index.value = e;
              },
              widgetBuilder: (index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % 15],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text('$index'),
                );
              },
            ),
          ),
          /*
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 150,
              onSelectedItemChanged: (index) {
                print(index);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    color: Colors.primaries[index % 15],
                    alignment: Alignment.center,
                    child: Text('$index'),
                  );
                },
                childCount: 77,
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}
