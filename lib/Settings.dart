import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:material_calculator/SetLanguage.dart';
import 'package:path_provider/path_provider.dart';
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
   String current_language = "";
   Map<dynamic, dynamic> language = {};
   int index;

   Settings(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.index);
   _SettingState createState() => _SettingState(mode_counter, modes, colores, fonts, current_language, language, index);

   }

   class _SettingState extends State<Settings>{
   int mode_counter = 1;
   List<IconData> modes = [];
   List<Color> colores = [];
   List<Color> fonts  = [];
   List<dynamic> options = [];
   List<dynamic> description = [];
   Map<dynamic, dynamic> language = {};
   String current_language = "";
   List<IconData> icons = [Icons.laptop_chromebook_rounded, Icons.language_rounded, Icons.coffee, Icons.star_border_rounded, Icons.info_rounded];
   List<String> images = ['assets/images/settings_en.png', 'assets/images/settings_es.png', 'assets/images/settings_fr.png', 'assets/images/settings_it.png', 'assets/images/settings_de.png'];
   int index;

   _SettingState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.index);

   _launchURL(String url) async {
     final Uri _url = Uri.parse(url);
     await launchUrl(_url,mode: LaunchMode.externalApplication);
   }

     @override
     void initState(){
     options = [language[current_language]["Settings"]["card1_title"], language[current_language]["Settings"]["card2_title"], language[current_language]["Settings"]["card3_title"], language[current_language]["Settings"]["card4_title"], language[current_language]["Settings"]["card5_title"]];
     description = [language[current_language]["Settings"]["card1_subtitle"], language[current_language]["Settings"]["card2_subtitle"], language[current_language]["Settings"]["card3_subtitle"], language[current_language]["Settings"]["card4_subtitle"], language[current_language]["Settings"]["card5_subtitle"]];
     super.initState();
     }

     @override
     Widget build(BuildContext context){
     return Scaffold(
         backgroundColor: colores[mode_counter],
       appBar: AppBar(
         backgroundColor: colores[mode_counter],
         title: Text(language[current_language]["Settings"]["title"],
           style: TextStyle(color: fonts[mode_counter]),

         ),
         iconTheme: IconThemeData(
           color: fonts[mode_counter], //change your color here
         ),
       ),

       body: Column(
       children: <Widget>[
       Text("\n"),
       Image.asset(images[index]),
       Text("\n"),
       Expanded(
       child : ListView.builder(
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
                         _launchURL("https://github.com/daviiid99/Material_Dialer");
                       }

                       else if (index == 1){
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => SetLanguage(mode_counter, modes, colores, fonts, current_language, language)),
                         );

                       } else if (index == 3){
                         _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.material_dialer");
                       }

                       else if (index == 4){
                       Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colores, fonts, current_language, language)),
                       );
                       }


               } )
               )
               ;}
         ,)
       )
       ]
       )
     )
     ;
   }
   }