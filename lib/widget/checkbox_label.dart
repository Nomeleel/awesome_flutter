import 'package:flutter/material.dart';

class CheckboxLabel extends StatefulWidget {
  const CheckboxLabel({Key? key, required this.value, required this.onChanged, required this.label}) : super(key: key);

  final bool value;

  final ValueChanged<bool> onChanged;

  final Widget label;

  @override
  State<CheckboxLabel> createState() => _CheckboxLabelState();
}

class _CheckboxLabelState extends State<CheckboxLabel> {
  late bool _value = widget.value;

  @override
  void didUpdateWidget(covariant CheckboxLabel oldWidget) {
    _value = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IgnorePointer(
            child: Checkbox(
              value: _value,
              onChanged: (_) {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            ),
          ),
          widget.label,
        ],
      ),
    );
  }
}
