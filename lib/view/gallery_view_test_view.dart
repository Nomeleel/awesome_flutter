import 'package:awesome_flutter/widget/gallery_view.dart';
import 'package:flutter/material.dart';
import '../widget/scaffold_view.dart';

class GalleryViewTestView extends StatelessWidget {
  const GalleryViewTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Gallery View Test View',
      body: GalleryView.builder(
        itemCount: 77,
        minPreRow: 2,
        maxPreRow: 7,
        duration: const Duration(milliseconds: 500),
        itemBuilder: (_, int index) {
          return Container(
            color: Colors.primaries[index % Colors.primaries.length],
            alignment: Alignment.center,
            child: Text('$index'),
          );
        },
      ),
    );
  }
}
