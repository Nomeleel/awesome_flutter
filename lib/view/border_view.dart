import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BorderView extends StatelessWidget {
  const BorderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 370,
        height: 100,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: SweepStadiumBorder(side: BorderSide(width: 5)),
        ),
      ),
    );
  }
}

class SweepStadiumBorder extends StadiumBorder {
  const SweepStadiumBorder({BorderSide side = BorderSide.none}) : super(side: side);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.amber,
    ];
    final endColor = Color.lerp(colors.first, colors.last, 0.5)!;
    final separation = 1.0 / (colors.length + 1);
    print(List.generate(colors.length + 1, (index) => (index + .5) * separation)..insert(0, 0.0));
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final Radius radius = Radius.circular(rect.shortestSide / 2.0);
        final paint = side.toPaint()
          ..shader = SweepGradient(
            colors: [endColor, ...colors, endColor],
            stops: List.generate(colors.length + 1, (index) => (index + .5) * separation)..insert(0, 0.0),
          ).createShader(rect);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius).deflate(side.width / 2.0), paint);

      // canvas.drawPath(getOuterPath(rect), paint);
    }
  }
}

class MyBorderSide extends BorderSide {
  @override
  Paint toPaint() {
    switch (style) {
      case BorderStyle.solid:
        return Paint()
          ..color = Colors.pink
          ..strokeWidth = 20
          ..style = PaintingStyle.stroke;
      // ..shader = LinearGradient(colors: [Colors.green, Colors.red]).createShader(Offset(200, 200) & Size(100, 20));
      case BorderStyle.none:
        return Paint()
          ..color = const Color(0x00000000)
          ..strokeWidth = 0.0
          ..style = PaintingStyle.stroke;
    }
  }
}
