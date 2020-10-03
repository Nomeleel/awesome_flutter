import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ShareView extends StatefulWidget {
  const ShareView({Key key, this.shareData}) : super(key: key);

  final Uint8List shareData;

  @override
  _ShareViewState createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Image.memory(widget.shareData),
        ),
      ],
    );
  }
}
