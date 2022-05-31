import 'package:flutter/material.dart';

import '/widget/scaffold_view.dart';

class TabPageLinkedScrollView extends StatefulWidget {
  const TabPageLinkedScrollView({Key? key}) : super(key: key);

  @override
  State<TabPageLinkedScrollView> createState() => _TabPageLinkedScrollViewState();
}

class _TabPageLinkedScrollViewState extends State<TabPageLinkedScrollView> {
  final int initialPage = 0;
  final int pageCount = 77;
  final double tabHeight = 50;

  late final ScrollController tabController = ScrollController(initialScrollOffset: initialPage * tabHeight);
  final ScrollController pageController = ScrollController();

  late final ValueNotifier<int> pageIndex = ValueNotifier(initialPage);

  late ValueKey<int> centerKey = ValueKey(initialPage);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Tab Page Scroll View',
      body: Row(
        children: [
          Container(
            width: 100,
            child: ValueListenableBuilder(
              valueListenable: pageIndex,
              builder: (BuildContext context, int value, Widget? child) {
                WidgetsBinding.instance.addPostFrameCallback((_) => tabJumpToTop());
                return ListView.builder(
                  itemCount: pageCount,
                  itemExtent: tabHeight,
                  controller: tabController,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          centerKey = ValueKey(index);
                        });
                        pageController.jumpTo(0);
                        pageIndex.value = index;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: value == index ? Colors.primaries[index % Colors.primaries.length] : null,
                          border: Border.symmetric(horizontal: BorderSide(color: Colors.black)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$index',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: CustomScrollView(
              center: centerKey,
              controller: pageController,
              cacheExtent: 0,
              slivers: [
                for (int pIndex = 0; pIndex < pageCount; pIndex++) ...[
                  SliverList(
                    key: ValueKey(pIndex),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (pageController.position.isScrollingNotifier.value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) => pageIndex.value = pIndex);
                        }

                        if (pIndex < centerKey.value) index = 10 - index;

                        return Container(
                          height: 100.0 + index * 10,
                          color: Colors.primaries[(index + pIndex) % Colors.primaries.length],
                          alignment: Alignment.center,
                          child: Text(
                            '$pIndex - $index',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        );
                      },
                      childCount: 10,
                    ),
                  ),

                  /// Other Sliver
                ],
                SliverToBoxAdapter(
                  child: Container(
                    height: 77,
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    alignment: Alignment.center,
                    child: Text('没有更多啦～'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void tabJumpToTop() {
    if (tabController.hasClients) {
      final position = tabController.position;
      final center = (pageIndex.value * tabHeight).clamp(position.minScrollExtent, position.maxScrollExtent);
      tabController.animateTo(center, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }
}
