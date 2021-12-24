import 'package:flutter/material.dart';

class HeroDemoView extends StatefulWidget {
  const HeroDemoView({Key? key}) : super(key: key);

  @override
  _HeroDemoViewState createState() => _HeroDemoViewState();
}

class _HeroDemoViewState extends State<HeroDemoView> {
  @override
  Widget build(BuildContext context) {
    print('First page build...');
    return GestureDetector(
      child: Hero(
        tag: 'Hero',
        child: Center(
          child: Container(
            height: 77,
            width: 77,
            color: Colors.purple,
          ),
        ),   
      ),
      onTap: () {
        print('Open second page...');
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Hero(
              tag: 'Hero',
              child: SecondPage(),
            );
          }
        ));
      },
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Second page build...');
    return Container(
      color: Colors.blue,
    );
  }
}