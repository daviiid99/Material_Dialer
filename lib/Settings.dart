import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:convert';
import 'dart:io';

 class Settings extends StatefulWidget{
   @override
   int mode_counter = 1;
   List<IconData> modes = [];
   List<Color> colores = [];
   List<Color> fonts  = [];
   Settings(this.mode_counter, this.modes, this.colores, this.fonts);
   _SettingState createState() => _SettingState(mode_counter, modes, colores, fonts);

   }

   class _SettingState extends State<Settings>{
   int mode_counter = 1;
   List<IconData> modes = [];
   List<Color> colores = [];
   List<Color> fonts  = [];
   List<String> options = ["Set country prefix", "Rate Us", "About Material Dialer"];
   List<String> description = ["Choose your default dialer prefix", "Rate this App on Google Play Store", "Check App details"];
   List<IconData> icons = [Icons.language_rounded, Icons.star_border_rounded, Icons.info_rounded];

   _SettingState(this.mode_counter, this.modes, this.colores, this.fonts);

   @override
     Widget build(BuildContext context){
     return Scaffold(
         backgroundColor: colores[mode_counter],
       appBar: AppBar(
         backgroundColor: colores[mode_counter],
         title: Text("My Settings",
           style: TextStyle(color: fonts[mode_counter]),

         ),
         iconTheme: IconThemeData(
           color: fonts[mode_counter], //change your color here
         ),
       ),

         body: ListView.builder(
             itemCount: options.length,
             itemBuilder: (context, index) {
               return ListTile(
                 tileColor: colores[mode_counter] ,
                 textColor: fonts[mode_counter],
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