/* 仅供参考, 作为副本, 不去升级2.0

import 'package:flutter/Widgets.dart';
import 'package:flutter/material.dart';

class CopilotTestView extends StatefulWidget {
  @override
  _CopilotTestViewState createState() => _CopilotTestViewState();
}

// 添加状态
class _CopilotTestViewState extends State<CopilotTestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CopilotTestView'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // 跳转页面
            RaisedButton(
              child: Text('跳转页面'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CopilotTestView(),
                  ),
                );
              },
            ),
            // 弹窗
            RaisedButton(
              child: Text('弹窗'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('弹窗'),
                      content: Text('弹窗内容'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('取消'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('确定'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            // 添加按钮
            RaisedButton(
              child: Text('添加按钮'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CopilotTestView(),
                  ),
                );
              },
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CopilotTestView()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
*/