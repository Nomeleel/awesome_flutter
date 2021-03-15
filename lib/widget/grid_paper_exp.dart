import 'package:flutter/widgets.dart';

class _GridPaperExpPainter extends CustomPainter {
  const _GridPaperExpPainter({
    this.color,
    this.strokeWidth,
    this.interval,
    this.divisions,
    this.subdivisions,
  });

  final Color color;
  final double strokeWidth;
  final double interval;
  final int divisions;
  final int subdivisions;

  @override
  void paint(Canvas canvas, Size size) {
    final interval = this.interval ?? size.width;
    final Paint linePaint = Paint()
      ..color = color;
    // Considering that if the line is too wide, the corners of the border will can't align，so the length of the line needs to be extended.
    final halfStrokeWidth = strokeWidth * 0.5;
    final divisionStrokeWidth = halfStrokeWidth;
    final subDivisionStrokeWidth = strokeWidth * 0.25;
    final double allDivisions = (divisions * subdivisions).toDouble();
    for (double x = 0.0; x <= size.width; x += interval / allDivisions) {
      linePaint.strokeWidth = (x % interval == 0.0) ? strokeWidth : 
        (x % (interval / subdivisions) == 0.0) ? divisionStrokeWidth : subDivisionStrokeWidth;
      canvas.drawLine(Offset(x, -halfStrokeWidth), Offset(x, size.height + halfStrokeWidth), linePaint);
    }
    for (double y = 0.0; y <= size.height; y += interval / allDivisions) {
      linePaint.strokeWidth = (y % interval == 0.0) ? strokeWidth : 
        (y % (interval / subdivisions) == 0.0) ? divisionStrokeWidth : subDivisionStrokeWidth;
      canvas.drawLine(Offset(-halfStrokeWidth, y), Offset(size.width + halfStrokeWidth, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(_GridPaperExpPainter oldPainter) {
    return oldPainter.color != color
        || oldPainter.strokeWidth != strokeWidth
        || oldPainter.interval != interval
        || oldPainter.divisions != divisions
        || oldPainter.subdivisions != subdivisions;
  }

  @override
  bool hitTest(Offset position) => false;
}

/// Expansion widget of GridPaper.
/// Increase the [strokeWidth] property, limited to 1 pixel in GridPaper, this widget can customize the this width.
class GridPaperExp extends GridPaper {
  const GridPaperExp({
    Key key,
    color = const Color(0xFF9C27B0),
    this.strokeWidth = 1.0,
    interval,
    divisions = 2,
    subdivisions = 5,
    child,
  }): assert(strokeWidth > 0, 'The "strokeWidth" property must be greater than zero. If the width is set to zero, the width will be set to the default value of Paint.'),
      super(
        key: key,
        color: color,
        interval: interval,
        divisions: divisions,
        subdivisions: subdivisions,
        child: child,
      );

  /// The width to draw the lines in the grid.
  ///
  /// Defaults to 1 pixel, can customize this value.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _GridPaperExpPainter(
        color: color,
        strokeWidth: strokeWidth,
        interval: interval,
        divisions: divisions,
        subdivisions: subdivisions,
      ),
      child: child,
    );
  }
}
