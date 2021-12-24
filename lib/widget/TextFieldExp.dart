import 'package:flutter/material.dart';

class TextFieldExp extends StatefulWidget {
  TextFieldExp({Key? key}) : super(key: key);

  @override
  _TextFieldExpState createState() => _TextFieldExpState();
}

class _TextFieldExpState extends State<TextFieldExp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple,
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 50.0,
          child: TextField(
            autofocus: true,
          ),
        ),
      ),
    );
  }
}
