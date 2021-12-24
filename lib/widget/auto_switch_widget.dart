import 'package:flutter/widgets.dart';

class AutoSwitchWidget extends StatefulWidget {
  AutoSwitchWidget({
    Key? key,
    required this.initWidget,
    required this.widgetMap,
    required this.widgetSwitch,
  }) : super(key: key);

  final String initWidget;
  final Map<String, Widget> widgetMap;
  final String Function(Size) widgetSwitch;

  @override
  _AutoSwitchWidgetState createState() => _AutoSwitchWidgetState();
}

class _AutoSwitchWidgetState extends State<AutoSwitchWidget> {
  Widget? _widget;

  @override
  void initState() {
    super.initState();

    _widget = widget.widgetMap[widget.initWidget];
    WidgetsBinding.instance?.addPostFrameCallback((d) {
      final widgetKey = widget.widgetSwitch(context.size!);
      if (widgetKey != widget.initWidget && widget.widgetMap.containsKey(widgetKey)) {
        setState(() {
          _widget = widget.widgetMap[widgetKey];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => _widget!;
}
