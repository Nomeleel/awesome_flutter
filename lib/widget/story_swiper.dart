/*
This widget is in reference: https://github.com/UdaraWanasinghe/StorySwiper
On this basis, the following modifications have been made:
1. Solved the problem that its item cannot be clicked(Stack -> AbsorbStack);
2. Solved the problem of at most scroll one item per swipe(PageView -> ListView);
3. Added some special logic for business needs(onPageChanged, onTap);
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget/absorb_stack.dart';

typedef Widget StorySwiperWidgetBuilder(int index);

class StorySwiper extends StatefulWidget {
  final StorySwiperWidgetBuilder widgetBuilder;
  final int itemCount;
  final int visiblePageCount;
  final double dx;
  final double dy;
  final double aspectRatio;
  final double depthFactor;
  final double paddingStart;
  final double verticalPadding;

  final Widget endWidget;
  final int limitLength;

  final Function onPageChanged;
  final Function onTap;

  StorySwiper.builder(
      {Key key,
      @required this.widgetBuilder,
      this.itemCount,
      this.visiblePageCount = 4,
      this.dx = 60,
      this.dy = 20,
      this.aspectRatio = 2 / 3,
      this.depthFactor = 0.2,
      this.paddingStart = 32,
      this.verticalPadding = 8,
      this.endWidget,
      this.limitLength,
      this.onPageChanged,
      this.onTap})
      : super(key: key);

  @override
  _StorySwiperState createState() => _StorySwiperState();
}

class _StorySwiperState extends State<StorySwiper> {
  PageController _pageController;
  double _pagePosition = 0;
  List<Widget> _widgetList = [];
  double itemWidth;
  int _pageIndex = 0;

  List numbers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _pagePosition = _pageController.page;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    itemWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AbsorbStack(
        absorbIndex: 0,
        children: <Widget>[
          _getPages(),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification && _pageIndex != _pageController.page) {
                Future.delayed(Duration.zero, () {
                  _pageController.animateToPage(
                    _pageController.page.round(),
                    duration: Duration(
                      milliseconds:
                          ((_pageController.page - _pageController.page.round()).abs() * 2000)
                              .floor(),
                    ),
                    curve: Curves.easeInOut,
                  );
                });
              }

              // onPageChanged
              if (widget.onPageChanged != null &&
                  notification.depth == 0 &&
                  widget.onPageChanged != null &&
                  notification is ScrollUpdateNotification) {
                final PageMetrics metrics = notification.metrics as PageMetrics;
                final int currentPage = metrics.page.round();
                if (currentPage != _pageIndex) {
                  _pageIndex = currentPage;
                  widget.onPageChanged(currentPage);
                }
              }
              return true;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              controller: _pageController,
              itemCount: (widget.itemCount > widget.limitLength
                  ? widget.limitLength + 1
                  : widget.itemCount),
              itemBuilder: (context, index) => Container(
                width: itemWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPages() {
    final List<Widget> pageList = [];
    final int currentPageIndex = _pagePosition.floor();
    final int lastPage = currentPageIndex + widget.visiblePageCount;
    final double width = MediaQuery.of(context).size.width;
    final double delta = _pagePosition - currentPageIndex;
    double top = -widget.dy * delta + widget.verticalPadding;
    double start = -widget.dx * delta + widget.paddingStart;

    if (widget.itemCount == 0) return Container();
    pageList.add(_getWidgetForValues(top, -width * delta + widget.paddingStart, currentPageIndex));

    int i;
    int rIndex = 1;
    for (i = currentPageIndex + 1; i < lastPage; i++) {
      start += widget.dx;
      top += widget.dy;
      if (i >= widget.itemCount) continue;
      pageList.add(_getWidgetForValues(top, start * _getDepthFactor(rIndex, delta), i));
      rIndex++;
    }
    if (i < widget.itemCount) {
      start += widget.dx * delta;
      top += widget.dy;
      pageList.add(_getWidgetForValues(top, start * _getDepthFactor(rIndex, delta), i));
    }
    if (numbers.isEmpty && widget.itemCount != 0) {
      for (var j = 0; j < pageList.length; ++j) {
        Positioned pageItem = pageList[j];
        numbers.add(pageItem.left);
      }
    }
    return Stack(children: pageList.reversed.toList());
  }

  double _getDepthFactor(int index, double delta) {
    return (1 - widget.depthFactor * (index - delta) / widget.visiblePageCount);
  }

  Widget _getWidgetForValues(double top, double start, int index) {
    Widget childWidget;
    if (index < _widgetList.length) {
      childWidget = _widgetList[index];
    } else {
      if (widget.limitLength > index) {
        childWidget = widget.widgetBuilder(index);
        _widgetList.insert(index, childWidget);
      } else if (widget.limitLength == index) {
        childWidget = widget.endWidget;
        _widgetList.insert(index, childWidget);
      }
    }

    if (widget.onTap != null) {
      childWidget = GestureDetector(
        onTap: () => widget.onTap(index),
        child: childWidget,
      );
    }

    return Positioned.directional(
      top: top,
      bottom: top,
      start: start,
      textDirection: TextDirection.ltr,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: childWidget,
      ),
    );
  }
}
