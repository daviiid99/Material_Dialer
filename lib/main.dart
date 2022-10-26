import 'package:flutter/material.dart';
import 'Dialer.dart';


// This Run our main App :)
void main() => runApp(MyFlutterApp());

class MyFlutterApp extends StatelessWidget{
  final String title = "Material App";
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: title,
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: Dialer(""),
    );
  }
}
