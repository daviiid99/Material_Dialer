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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Dialer(),
    );
  }
}
