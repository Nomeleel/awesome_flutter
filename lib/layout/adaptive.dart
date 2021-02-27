import 'package:flutter/material.dart';
import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';

bool isDisplayDesktop(BuildContext context) => getWindowType(context) >= AdaptiveWindowType.medium;
