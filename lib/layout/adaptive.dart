import 'package:flutter/material.dart';
import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';

bool isDisplayDesktop(Size size) => getWindowType(size) >= AdaptiveWindowType.medium;

AdaptiveWindowType getWindowType(Size size) {
  final width = size.width;
  for (BreakpointSystemEntry entry in breakpointSystem) {
    if (entry.range.start <= width && width < entry.range.end + 1) {
      return entry.adaptiveWindowType;
    }
  }
  throw AssertionError('Something unexpected happened');
}