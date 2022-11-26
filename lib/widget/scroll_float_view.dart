import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef AnimatedValueContainerBuilder = Widget Function(
  BuildContext context,
  double animatedIn,
  double animated,
  double animatedOut,
  double childHeight,
  Widget? child,
);

class ScrollFloatContainer extends ScrollFloatWidget {
  const ScrollFloatContainer({
    super.key,
    this.childHeight,
    required double containerHeight,
    required this.animatedBuilder,
    required super.childBuilder,
    this.floatIn = false,
    this.floatOut = false,
  }) : super(height: containerHeight);

  final double? childHeight;
  final AnimatedValueContainerBuilder animatedBuilder;
  final bool floatIn;
  final bool floatOut;

  @override
  Widget floatBuilder(BuildContext context, double offset, double viewportDimension, Widget? child) {
    final animatedHeight = height - viewportDimension;
    double animatedIn = 0, animated = 0, animatedOut = 0;
    double float = offset / animatedHeight;
    if (offset >= -viewportDimension) {
      animatedIn = clampDouble((offset + viewportDimension) / viewportDimension, 0.0, 1.0);
    }
    if (offset >= 0) {
      animated = clampDouble(float, 0.0, 1.0);
    }
    if (offset >= animatedHeight) {
      animatedOut = clampDouble((offset - animatedHeight) / viewportDimension, 0.0, 1.0);
    }

    final double align = (float < 0 && !floatIn) ? 0 : ((float > 1 && !floatOut) ? 1 : float);
    final double resetHeight = (childHeight?.clamp(0, viewportDimension) ?? viewportDimension);

    return Align(
      alignment: Alignment(0, align * 2 - 1),
      child: SizedBox(
        height: viewportDimension,
        child: animatedBuilder(context, animatedIn, animated, animatedOut, resetHeight, child),
      ),
    );
  }
}

typedef AnimatedValueBoxBuilder = Widget Function(BuildContext context, double animated, Widget? child);

class ScrollFloatBox extends ScrollFloatWidget {
  const ScrollFloatBox({
    super.key,
    required super.height,
    required this.animatedBuilder,
    required super.childBuilder,
  });

  final AnimatedValueBoxBuilder animatedBuilder;

  @override
  Widget floatBuilder(BuildContext context, double offset, double viewportDimension, Widget? child) {
    double animated = clampDouble((offset + viewportDimension) / (viewportDimension + height), 0.0, 1.0);

    return animatedBuilder(context, animated, child);
  }
}

abstract class ScrollFloatWidget extends StatelessWidget {
  const ScrollFloatWidget({
    super.key,
    required this.height,
    required this.childBuilder,
  });

  final double height;
  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    final scrollable = Scrollable.of(context);
    if (scrollable == null) return SizedBox.shrink();
    final position = scrollable.position;

    double? start;
    return SizedBox(
      height: height,
      child: AnimatedBuilder(
        animation: position,
        builder: (ctx, child) {
          start ??= _startOffsetInScrollView(context, position);
          if (start == null) return SizedBox.shrink();

          final viewportDimension = position.viewportDimension;

          final offset = position.pixels - start!;
          if (offset < -viewportDimension || offset > height) return SizedBox.shrink();

          return floatBuilder(context, offset, viewportDimension, child);
        },
        child: childBuilder(context),
      ),
    );
  }

  Widget floatBuilder(BuildContext context, double offset, double viewportDimension, Widget? child);

  double? _startOffsetInScrollView(BuildContext context, ScrollPosition position) => position.startOffset(context);
}

extension ScrollPositionExtension on ScrollPosition {
  double? startOffset(BuildContext context) {
    RenderObject? object = context.findRenderObject();
    if (object != null) {
      return RenderAbstractViewport.of(object)
          ?.getOffsetToReveal(object, 0.0)
          .offset
          .clamp(minScrollExtent, maxScrollExtent);
    }
    return null;
  }
}
