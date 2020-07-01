import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SidePanel extends StatefulWidget {
  const SidePanel(
      {Key key,
      this.orientation = SidePanelOrientation.end,
      this.mainAxisHeight,
      this.child,
      this.onSwitched,})
      : super(key: key);

  final SidePanelOrientation orientation;

  final double mainAxisHeight;

  final Widget child;

  final void Function(bool) onSwitched;

  @override
  _SidePanelState createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final Size size = MediaQuery.of(context).size;
    final double windowSideMaxLave = math.max(size.height, size.width) - 21;
    final double windowSideMin = math.min(size.height, size.width);
    final double mainAxisHeight = widget.mainAxisHeight ?? windowSideMin;

    final bool isPortrait = size.width < size.height;
    final bool isEnd = (widget.orientation ?? SidePanelOrientation.end) ==
        SidePanelOrientation.end;

    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          isPortrait ? 0 : isEnd ? windowSideMaxLave : -mainAxisHeight,
          !isPortrait ? 0 : isEnd ? windowSideMaxLave : -mainAxisHeight,
          isPortrait ? 0 : !isEnd ? windowSideMaxLave : -mainAxisHeight,
          !isPortrait ? 0 : !isEnd ? windowSideMaxLave : -mainAxisHeight,
        ),
        end: RelativeRect.fromLTRB(
          !isPortrait && isEnd ? windowSideMaxLave - mainAxisHeight : 0,
          isPortrait && isEnd ? windowSideMaxLave - mainAxisHeight : 0,
          !isPortrait && !isEnd ? windowSideMaxLave - mainAxisHeight : 0,
          isPortrait && !isEnd ? windowSideMaxLave - mainAxisHeight : 0,
        ),
      ).animate(controller),
      child: Container(
        height: isPortrait ? mainAxisHeight + 21 : windowSideMin,
        width: !isPortrait ? mainAxisHeight + 21 : windowSideMin,
        child: Flex(
          direction: isPortrait ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!isEnd) Expanded(child: widget.child),
            Container(
              width: isPortrait ? 77 : 21,
              height: !isPortrait ? 77 : 21,
              padding: const EdgeInsets.all(7),
              child: CupertinoButton(
                child: const Text(''),
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                onPressed: () {
                  bool isOpen = controller.status != AnimationStatus.completed;
                  widget.onSwitched(isOpen);
                  isOpen ? controller.forward() : controller.reverse();
                },
              ),
            ),
            if (isEnd) Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

enum SidePanelOrientation {
  start,
  end,
}
