import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:awesome_flutter/widget/tab_view.dart';
import 'package:flutter/material.dart';

class InteractiveViewerTestView extends StatefulWidget {
  const InteractiveViewerTestView({Key? key}) : super(key: key);

  @override
  _InteractiveViewerTestViewState createState() => _InteractiveViewerTestViewState();
}

class _InteractiveViewerTestViewState extends State<InteractiveViewerTestView> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Interactive Viewer Test View',
      body: TabView(
        tabs: [
          'Constrained',
          'Scale',
        ],
        children: [
          InteractiveViewerTestConstrained(),
          InteractiveViewerTestScale(),
        ],
      ),
    );
  }
}

class InteractiveViewerTestConstrained extends StatelessWidget {
  const InteractiveViewerTestConstrained({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> constrained = ValueNotifier<bool>(true);
    return ValueListenableBuilder(
      valueListenable: constrained,
      builder: (BuildContext context, bool value, Widget? child) {
        return Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                constrained: constrained.value,
                child: child!,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 77.77),
              child: IconButton(
                icon: Icon(constrained.value ? Icons.fullscreen : Icons.fullscreen_exit),
                color: Colors.blue,
                onPressed: () {
                  constrained.value = !constrained.value;
                },
              ),
            ),
          ],
        );
      },
      child: Image.asset('assets/images/SaoSiMing.jpg'),
    );
  }
}

class InteractiveViewerTestScale extends StatelessWidget {
  const InteractiveViewerTestScale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // InteractiveViewer.builder
    return InteractiveViewer(
      scaleEnabled: true,
      minScale: 0.7,
      maxScale: 2.0,
      child: Image.asset(
        'assets/images/SaoSiMing.jpg',
        fit: BoxFit.cover,
      ),
      // child: Container(
      //   child: GridView.builder(
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 7,
      //       childAspectRatio: 0.5,
      //     ),
      //     itemCount: 77,
      //     itemBuilder: (BuildContext context, int index) => Stack(
      //       children: [
      //         Image.asset(
      //           'assets/images/SaoSiMing.jpg',
      //           fit: BoxFit.cover,
      //         ),
      //         Center(
      //           child: Text(
      //             '$index',
      //             style: Theme.of(context).textTheme.bodyText1,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
