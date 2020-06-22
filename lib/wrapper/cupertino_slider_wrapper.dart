import 'package:flutter/cupertino.dart';

class CupertinoSliderWrapper extends StatefulWidget {
  const CupertinoSliderWrapper({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.thumbColor = CupertinoColors.white,
  }) : super(key: key);

  factory CupertinoSliderWrapper.from(CupertinoSlider slider) {
    return CupertinoSliderWrapper(
      key: slider.key, 
      onChanged: slider.onChanged, 
      value: slider.value,
      onChangeStart: slider.onChangeStart,
      onChangeEnd: slider.onChangeEnd,
      min: slider.min,
      max: slider.max,
      divisions: slider.divisions,
      activeColor: slider.activeColor,
      thumbColor: slider.thumbColor,
    );
  }

  final double value;

  final ValueChanged<double> onChanged;

  final ValueChanged<double> onChangeStart;

  final ValueChanged<double> onChangeEnd;

  final double min;

  final double max;

  final int divisions;

  final Color activeColor;

  final Color thumbColor;

  @override
  _CupertinoSliderWrapperState createState() => _CupertinoSliderWrapperState();
}

class _CupertinoSliderWrapperState extends State<CupertinoSliderWrapper> {
  double _value;
  
  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoSlider(
      value: _value,
      min: widget.min,
      max: widget.max,
      activeColor: widget.activeColor,
      onChanged: (double value) {
        widget.onChanged(value);
        setState(() {
          _value = value;
        });
      },
    );
  }
}