import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:convert';
import 'dart:io';

 class Settings extends StatefulWidget{
   @override
   _SettingState createState() => _SettingState();

   }

   class _SettingState extends State<Settings>{

   @override
     Widget build(BuildContext context){
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.black,
         title: const Text("Settings"),
       ),
     );
   }
   }