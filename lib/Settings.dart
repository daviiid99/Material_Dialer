import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:convert';
import 'dart:io';

 class Settings extends StatefulWidget{
   @override
   _SettingState createState() => _SettingState();

   }

   class _SettingState extends State<Settings>{

   List<String> options = ["Set country prefix", "Rate Us", "About Material Dialer"];
   List<String> description = ["Choose your default dialer prefix", "Rate this App on Google Play Store", "Check App details"];
   List<IconData> icons = [Icons.language_rounded, Icons.star_border_rounded, Icons.info_rounded];
   @override
     Widget build(BuildContext context){
     return Scaffold(
         backgroundColor: Colors.black,
       appBar: AppBar(
         backgroundColor: Colors.black,
         title: const Text("Settings"),
       ),

         body: ListView.builder(
             itemCount: options.length,
             itemBuilder: (context, index) {
               return ListTile(
                 tileColor: Colors.black ,
                 textColor: Colors.white,
                   leading: IconButton(
                     icon : Icon(icons[index], color: Colors.blueAccent,),
                     onPressed: (){
                       GestureDetector(
                           child: Text(index.toString()),
                           onTap: () =>
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(index.toString()))
                               ));},

                   ),
                 title: Text(options[index]),
                 subtitle: Text(description[index]),

               );},));
   }
   }