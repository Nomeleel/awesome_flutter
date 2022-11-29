import 'package:flutter/material.dart';

class TabBarInitIndicatorImageView extends StatefulWidget {
  const TabBarInitIndicatorImageView({super.key});

  @override
  _TabBarInitIndicatorImageViewState createState() => _TabBarInitIndicatorImageViewState();
}

class _TabBarInitIndicatorImageViewState extends State<TabBarInitIndicatorImageView> with TickerProviderStateMixin {
  final image = const AssetImage('assets/images/iPhoneCase12.png');

  late TabController tabController;

  /* solution 2: precacheImage
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(image, context).then(_markNeedsBuild);
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBar Indicator Image View'),
      ),
      body: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.pink,
            child: TabBar(
              // For solution 1 must be set 'false',
              isScrollable: false,
              controller: TabController(length: 5, vsync: this),
              indicator: BoxDecoration(
                // image: DecorationImage(
                //   image: image,
                //   alignment: Alignment.bottomCenter,
                // ),
                // solution 3: callback
                image: DecorationImageExp(
                  onChanged: _markNeedsBuild,
                  image: image,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              tabs: List.generate(5, (index) => Tab(text: '$index')),
            ),
          ),
          /* solution 2: hide precacheImage
          Expanded(
            child: Container(
              height: 0.0,
              width: 0.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }

  void _markNeedsBuild([_]) {
    print('--------_markNeedsBuild----------');
    if(mounted) setState(() {});
  }
}

class DecorationImageExp extends DecorationImage {
  const DecorationImageExp({
    required super.image,
    super.onError,
    super.colorFilter,
    super.fit,
    super.alignment = Alignment.center,
    super.centerSlice,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    super.scale = 1.0,
    super.opacity = 1.0,
    super.filterQuality = FilterQuality.low,
    super.invertColors = false,
    super.isAntiAlias = false,
    required this.onChanged,
  });

  final VoidCallback onChanged;

  DecorationImagePainter createPainter(VoidCallback onChanged) => super.createPainter(this.onChanged);
}
