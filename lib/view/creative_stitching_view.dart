import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../creative/creative_stitching.dart';

class CreativeStitchingView extends StatefulWidget {
  CreativeStitchingView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {
  
  List<Widget> _imageList;
  List<ByteData> _byteDataList;

  @override
  Widget build(BuildContext context) {
    var defText = (text) => Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        decoration: TextDecoration.none,
      )
    );
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[ 
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: _imageList == null ? 
                defText('Please click this button') :
                _imageList.length == 0 ? 
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ) :
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      children: _imageList,
                    ),
                  ),
            ),
            if (_imageList == null) 
              RaisedButton(
                onPressed: () async {
                  setState(() { 
                    _imageList = List<Widget>();
                  });
                  String mainImageAsset = 'assets/images/SaoSiMing.jpg';
                  List<String> multipleImageList = List.generate(15, (index) => 
                    'assets/images/LuoWang.png')
                    ..add(mainImageAsset)
                    ..add('assets/images/LuoWang.png');
                  creativeStitchingByAsset(mainImageAsset, multipleImageList, colCount: 3).then((byteDataList) {
                    setState(() {
                      _byteDataList = byteDataList;
                      byteDataList.forEach((byteData) {
                        var uniqueTag = DateTime.now().toString() + math.Random().nextInt(77).toString();
                        _imageList.add(GestureDetector(
                          child: Hero(
                            tag: uniqueTag,
                            child: Image.memory(
                              byteData.buffer.asUint8List(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return Hero(
                                  tag: uniqueTag,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget> [
                                        Image.memory(
                                          byteData.buffer.asUint8List(),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ));
                          },
                        ));
                      });
                    });
                  });
                },
                child: defText('Go'),
              ),
            if (_byteDataList != null)
              RaisedButton(
                onPressed: () async {
                  // Only test for Android.
                  final String pathPrefix = '/storage/emulated/0/Download/${DateTime.now().minute}_';
                  for(int i = 0; i < _byteDataList.length; i++ ) {
                    await File('$pathPrefix$i.png').writeAsBytes(
                      _byteDataList[i].buffer.asUint8List());
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
}
