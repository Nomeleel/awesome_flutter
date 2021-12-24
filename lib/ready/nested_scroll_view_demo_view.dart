import 'package:flutter/material.dart';

class NestedScrollViewDemoView extends StatefulWidget {
  const NestedScrollViewDemoView({Key? key}) : super(key: key);

  @override
  _NestedScrollViewDemoViewState createState() => _NestedScrollViewDemoViewState();
}

class _NestedScrollViewDemoViewState extends State<NestedScrollViewDemoView> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            title: Text(
              '少司命',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.purple,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '少司命',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              background: Image.asset(
                'assets/images/SaoSiMing.jpg',
                fit: BoxFit.cover,
              ),
            ),

            /// 这里可以扩展：
            /// 添加一个AppBar类型，当滚动到顶部时，需要替换掉原来的appbar，因为如果开始设置title字体为白色
            /// 滚到顶部时出现的白色背景，将看不见字体
            /// 修改目标为： _SliverAppBarDelegate
          ),
        ];
      },
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 80,
            color: Colors.primaries[index % Colors.primaries.length],
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}
