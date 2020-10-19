import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextExpansion extends StatefulWidget {
  TextExpansion({Key key, this.text}) : super(key: key);

  final String text;

  @override
  TextExpansionState createState() => TextExpansionState();
}

class TextExpansionState extends State<TextExpansion> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      maxLines: 2,
      text: TextSpan(
        text: widget.text,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    if (!textPainter.didExceedMaxLines) {
      return Text(
        widget.text,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      );
    } else {
      if (_expand) {
        return switchWidget(
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        );
      } else {
        return Stack(
          children: [
            Text(
              widget.text,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: switchWidget(
                Container(
                  height: 30.0,
                  width: 30.0,
                  color: Colors.purple,
                ),
              ),
            )
          ],
        );
      }
    }
  }

  Widget switchWidget(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () {
        setState(() {
          _expand = !_expand;
        });
      },
    );
  }
}
