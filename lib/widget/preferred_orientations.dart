import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PreferredOrientations extends StatefulWidget {
  const PreferredOrientations({Key key, this.child, this.orientations}) : super(key: key);

  final Widget child;

  final List<DeviceOrientation> orientations;

  @override
  _PreferredOrientationsState createState() => _PreferredOrientationsState();
}

class _PreferredOrientationsState extends State<PreferredOrientations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SystemChrome.setPreferredOrientations(widget.orientations);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
