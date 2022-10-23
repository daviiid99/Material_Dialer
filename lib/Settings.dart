import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:convert';
import 'dart:io';
import 'MaterialDIaler.dart';
import 'package:url_launcher/url_launcher.dart';


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
   List<String> options = ["View Project Source Code", "Donate Us", "Rate Us", "About Material Dialer"];
   List<String> description = ["Open the official GitHub page", "Buy me a coffee", "Rate this App on Google Play Store", "Check App details"];
   List<IconData> icons = [Icons.language_rounded, Icons.coffee, Icons.star_border_rounded, Icons.info_rounded];

   _SettingState(this.mode_counter, this.modes, this.colores, this.fonts);

   _launchURL() async {
     const url = 'https://github.com/daviiid99/Material_Dialer';
     final Uri _url = Uri.parse(url);
     await launchUrl(_url,mode: LaunchMode.externalApplication);
   }
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
               return Card(
                 child: ListTile(

                 tileColor: colores[mode_counter] ,
                 textColor: fonts[mode_counter],
                   title: Text(options[index]),
                   subtitle: Text(description[index]),
                     leading: Icon(icons[index], color: fonts[mode_counter]),
                     onTap: () {

                       if (index == 0){
                         _launchURL();
                       }
                       if(index == 3){
                       Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colores, fonts)),
                       );
                       }


               } ));},));
   }
   }