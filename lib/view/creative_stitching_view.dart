import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../creative/creative_stitching.dart';
import '../custom/animation/gesture_scale_transition.dart';

// TODO(Nomeleel): 不是正方形了
class CreativeStitchingView extends StatefulWidget {
  const CreativeStitchingView({Key? key}) : super(key: key);

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {
  List<ByteData>? _byteDataList;
// 布局问题
  @override
  Widget build(BuildContext context) {
    var defText = (text) => Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        );
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: _byteDataList == null
                  ? defText('Please click this button')
                  : _byteDataList!.length == 0
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : AspectRatio(
                          aspectRatio: 1.0,
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                            children: imageList(),
                          ),
                        ),
            ),
            if (_byteDataList == null)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _byteDataList = <ByteData>[];
                  });
                  String mainImageAsset = 'assets/images/BaoErJie.jpg';
                  List<String> multipleImageList = List.generate(15, (index) => 'assets/images/SaoSiMing.jpg')
                    ..add(mainImageAsset)
                    ..add('assets/images/LuoWang.png');
                  creativeStitchingByAsset(mainImageAsset, multipleImageList, colCount: 3).then((byteDataList) {
                    setState(() {
                      _byteDataList = byteDataList;
                    });
                  });
                },
                child: defText('Go'),
              ),
            if (_byteDataList?.isNotEmpty ?? false)
              ElevatedButton(
                onPressed: () async {
                  // Only test for Android.
                  final String pathPrefix = '/storage/emulated/0/Download/${DateTime.now().minute}_';
                  for (int i = 0; i < _byteDataList!.length; i++) {
                    await File('$pathPrefix$i.png').writeAsBytes(_byteDataList![i].buffer.asUint8List());
                  }
                  print('Save finish...');
                },
                child: defText('Export'),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> imageList() {
    List<Widget> imageList = <Widget>[];
    final detailViewList = _byteDataList!
        .map<Widget>(
          (item) => ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              GestureScaleTransition(
                child: Image.memory(
                  item.buffer.asUint8List(),
                  fit: BoxFit.fitWidth,
                ),
                callBack: () => Navigator.pop(context),
              ),
            ],
          ),
        )
        .toList();

    for (int i = 0; i < _byteDataList!.length; i++) {
      imageList.add(GestureDetector(
        child: Image.memory(
          _byteDataList![i].buffer.asUint8List(),
          fit: BoxFit.cover,
        ),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ScaleTransition(
                  scale: animation,
                  child: PageView(
                    controller: PageController(
                      initialPage: i,
                    ),
                    physics: BouncingScrollPhysics(),
                    children: detailViewList,
                  ),
                );
              },
            ),
          );
        },
      ));
    }

    return imageList;
  }
}
