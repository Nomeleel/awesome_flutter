import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextExpansion extends StatefulWidget {
  const TextExpansion(this.text, this.maxLines, {Key? key, this.maxWidth, required this.style, this.expansionWidget})
      : super(key: key);

  final String text;
  final int maxLines;
  final TextStyle style;
  final double? maxWidth;
  final Widget? expansionWidget;

  @override
  TextExpansionState createState() => TextExpansionState();
}

class TextExpansionState extends State<TextExpansion> {
  bool _expand = false;
  bool? _didExceedMaxLines;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _didExceedMaxLines = didExceedMaxLines();
  }

  bool didExceedMaxLines() {
    final TextPainter textPainter = TextPainter(
      maxLines: widget.maxLines,
      text: TextSpan(
        text: widget.text,
        style: widget.style,
      ),
      textDirection: TextDirection.ltr,
    );
    // 可以获取父容器的宽度，最大不超过屏幕宽度
    textPainter.layout(maxWidth: widget.maxWidth ?? MediaQuery.of(context).size.width);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    if (_didExceedMaxLines!) {
      if (_expand) {
        return switchWidget(text());
      } else {
        if (widget.expansionWidget == null) {
          return switchWidget(text(widget.maxLines));
        } else {
          return Stack(
            children: [
              text(widget.maxLines),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: switchWidget(widget.expansionWidget!),
              )
            ],
          );
        }
      }
    } else {
      return text();
    }
  }

  Text text([int? maxLines]) {
    return Text(
      widget.text,
      maxLines: maxLines,
      style: widget.style,
    );
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
