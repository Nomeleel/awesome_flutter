import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class DraggableScrollableSheetTestView extends StatelessWidget {
  const DraggableScrollableSheetTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Draggable Scrollable Sheet TestViewTest View',
      body: _builder(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: _builder,
          );
        },
        child: const Text('GO'),
      ),
    );
  }

  Widget _builder(BuildContext context) {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        initialChildSize: .7,
        // snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.blue[100],
            child: ListView.builder(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          );
        },
      ),
    );
  }
}
