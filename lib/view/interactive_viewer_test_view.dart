import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InteractiveViewerTestView extends StatefulWidget {
  const InteractiveViewerTestView({Key key}) : super(key: key);

  @override
  _InteractiveViewerTestViewState createState() => _InteractiveViewerTestViewState();
}

class _InteractiveViewerTestViewState extends State<InteractiveViewerTestView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Interactive Viewer Test View',
      body: InteractiveViewerTestConstrained(),
    );
  }
}

class InteractiveViewerTestConstrained extends StatefulWidget {
  InteractiveViewerTestConstrained({Key key}) : super(key: key);

  @override
  _InteractiveViewerTestConstrainedState createState() => _InteractiveViewerTestConstrainedState();
}

class _InteractiveViewerTestConstrainedState extends State<InteractiveViewerTestConstrained> {
  bool _constrained = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InteractiveViewer(
            constrained: _constrained,
            child: Image.asset('assets/images/SaoSiMing.jpg'),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 77.77),
          child: FloatingActionButton(
            child: Icon(_constrained ? Icons.fullscreen : Icons.fullscreen_exit),
            onPressed: () {
              setState(() {
                _constrained = !_constrained;
              });
            },
          ),
        ),
      ],
    );
  }
}
