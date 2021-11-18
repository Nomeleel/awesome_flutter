import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../widget/scaffold_view.dart';

class TextInputFormatterTestView extends StatelessWidget {
  const TextInputFormatterTestView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return ScaffoldView(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: controller,
            inputFormatters: [
              CustomLengthLimitingTextInputFormatter(
                5,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
              )
            ],
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (BuildContext context, TextEditingValue value, Widget child) {
              return Text(
                'Text length: ${controller.text.characters.length}\n'
                'merge length: ${CustomLengthLimitingTextInputFormatter.mergedTextLength(controller.text)}',
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomLengthLimitingTextInputFormatter extends LengthLimitingTextInputFormatter {
  CustomLengthLimitingTextInputFormatter(
    int maxLength, {
    MaxLengthEnforcement maxLengthEnforcement,
  }) : super(maxLength, maxLengthEnforcement: maxLengthEnforcement);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int maxLength = this.maxLength;
    final int mergedLength = mergedTextLength(newValue.text);

    if (maxLength == null || maxLength == -1 || mergedLength <= maxLength) {
      return newValue;
    }

    assert(maxLength > 0);

    switch (maxLengthEnforcement ?? LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement()) {
      case MaxLengthEnforcement.enforced:
        // If already at the maximum and tried to enter even more, and has no
        // selection, keep the old value.
        if (mergedLength == maxLength && oldValue.selection.isCollapsed) {
          return oldValue;
        }

        // Enforced to return a truncated value.
        return truncate(newValue, maxLength);
      case MaxLengthEnforcement.truncateAfterCompositionEnds:
        // If already at the maximum and tried to enter even more, and the old
        // value is not composing, keep the old value.
        if (mergedLength == maxLength && !oldValue.composing.isValid) {
          return oldValue;
        }

        // Temporarily exempt `newValue` from the maxLength limit if it has a
        // composing text going and no enforcement to the composing value, until
        // the composing is finished.
        if (newValue.composing.isValid) {
          return newValue;
        }

        return truncate(newValue, maxLength);
      default:
        return newValue;
    }
  }

  static int mergedTextLength(String text) {
    if (text.isEmpty) return 0;
    Iterator iterator = text.characters.iterator;
    int length = 0;
    bool hasMerge = false;
    while (iterator.moveNext()) {
      final String current = iterator.current;
      if (current.length <= 1 && current.codeUnits.first < 128) {
        if (hasMerge) {
          hasMerge = false;
        } else {
          hasMerge = true;
          length++;
        }
      } else {
        hasMerge = false;
        length++;
      }
    }
    return length;
  }

  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    String truncated = value.text;
    print('value: ${value.text}');
    final int mergedLength = mergedTextLength(value.text);
    if (mergedLength > maxLength) {
      print('mergedLength: $mergedLength');
      truncated = truncatedText(value.text, maxLength);
    }

    print(truncated);

    return TextEditingValue(
      text: truncated,
      selection: value.selection.copyWith(
        baseOffset: math.min(value.selection.start, truncated.length),
        extentOffset: math.min(value.selection.end, truncated.length),
      ),
      composing: !value.composing.isCollapsed && truncated.length > value.composing.start
          ? TextRange(
              start: value.composing.start,
              end: math.min(value.composing.end, truncated.length),
            )
          : TextRange.empty,
    );
  }

  static String truncatedText(String text, int maxLength) {
    bool hasMerge = false;
    for (int i = 0; i < text.characters.length; i++) {
      final String current = text.characters.elementAt(i);
      if (current.length <= 1 && current.codeUnits.first < 128) {
        if (hasMerge) {
          hasMerge = false;
        } else {
          hasMerge = true;
          maxLength--;
          continue;
        }
      } else {
        hasMerge = false;
        maxLength--;
      }

      if (maxLength == 0) return text.characters.getRange(0, i + 1).string;
    }

    return text;
  }
}
