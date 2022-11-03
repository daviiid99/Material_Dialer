import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:material_calculator/SetLanguage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'MaterialDIaler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Profile.dart';


 class Settings extends StatefulWidget{
   @override
   int mode_counter = 1;
   List<IconData> modes = [];
   List<Color> colores = [];
   List<Color> fonts  = [];
   String current_language = "";
   Map<dynamic, dynamic> language = {};
   Map<dynamic, dynamic> user = {};

   int index;

   Settings(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.index, this.user);
   _SettingState createState() => _SettingState(mode_counter, modes, colores, fonts, current_language, language, index, user);

   }

   class _SettingState extends State<Settings>{
   int mode_counter = 1;
   List<IconData> modes = [];
   List<Color> colores = [];
   List<Color> fonts  = [];
   List<dynamic> options = [];
   List<dynamic> description = [];
   Map<dynamic, dynamic> language = {};
   Map<dynamic, dynamic> user = {};
   String current_language = "";
   List<IconData> icons = [Icons.laptop_chromebook_rounded, Icons.star_border_rounded, Icons.security_rounded, Icons.info_rounded];
   List<String> images = ['assets/images/settings_en.png', 'assets/images/settings_es.png', 'assets/images/settings_fr.png', 'assets/images/settings_it.png', 'assets/images/settings_de.png'];
   int index;

   _SettingState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.index, this.user);

   _launchURL(String url) async {
     final Uri _url = Uri.parse(url);
     await launchUrl(_url,mode: LaunchMode.externalApplication);
   }

   void userMenu()  {
     showDialog(
         context: context,
         builder: (context) {
           return StatefulBuilder(
               builder: (context, setState) {
                 return WillPopScope(
                     onWillPop: () async  {

                       int back = 2;
                       while (back > 0){
                         back -=1;
                         Navigator.pop(context);
                       }

                       return false;

                       },
                 child : AlertDialog(
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(15.0))),
                     backgroundColor: colores[mode_counter],
                     content: SingleChildScrollView(
                         child: Column(
                           children: [

                             CircleAvatar(
                                 minRadius: 50,
                                 maxRadius: 75,
                                 backgroundColor: Colors.transparent,
                                 child : ClipRRect(
                                   borderRadius: BorderRadius.circular(8.0),
                                   child: Image.file(File(user["photo"])),
                                 )
                             ),

                             SizedBox(height: 30,),

                             Row(
                                 children : [
                                   TextButton.icon(
                                     style: TextButton.styleFrom(
                                       textStyle: TextStyle(color: Colors.white),
                                       backgroundColor: Colors.black26,
                                       fixedSize: const Size(120, 120),
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(
                                             10.0),
                                       ),
                                     ),
                                     icon: Icon(Icons.laptop_rounded, color: Colors.white, size: 102,),
                                     onPressed: () => {
                                     _launchURL("https://github.com/daviiid99/Material_Dialer")
                                     }, label: Text(""),
                                   ),

                                   SizedBox(width: 20,),

                                   TextButton.icon(
                                     style: TextButton.styleFrom(
                                       textStyle: TextStyle(color: Colors.white),
                                       backgroundColor: Colors.amber,
                                       fixedSize: const Size(120, 120),
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(
                                             10.0),
                                       ),
                                     ),
                                     icon: Icon(Icons.star_border_rounded, color: Colors.white, size: 102,),
                                     onPressed: () => {
                                     _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.material_dialer")
                                     }, label: Text(""),
                                   ),
                                 ]
                             ),

                             SizedBox(height: 30,),

                             Row(
                                 children : [
                                   TextButton.icon(
                                     style: TextButton.styleFrom(
                                       textStyle: TextStyle(color: Colors.white),
                                       backgroundColor: Colors.green,
                                       fixedSize: const Size(120, 120),
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(
                                             10.0),
                                       ),
                                     ),
                                     icon: Icon(Icons.security_rounded, color: Colors.white, size: 102,),
                                     onPressed: () => {
                                     _launchURL("https://daviiid99.github.io/Material_Dialer/privacy.html")
                                     }, label: Text(""),
                                   ),
                                   SizedBox(width: 20,),

                                   TextButton.icon(
                                     style: TextButton.styleFrom(
                                       textStyle: TextStyle(color: Colors.white),
                                       backgroundColor: Colors.redAccent,
                                       fixedSize: const Size(120, 120),
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(
                                             10.0),
                                       ),
                                     ),
                                     icon: Icon(Icons.info_rounded, color: Colors.white, size: 102,),
                                     onPressed: () async {
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colores, fonts, current_language, language)),
                                       );
                                     }, label: Text(""),
                                   ),
                                 ]
                             ),
                           ],

                         ))));
               }
           );
         }
     );
   }

     @override
     void initState(){
       // Set full screen mode for an inmersive experience
       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

       userMenu();

       options = [language[current_language]["Settings"]["card1_title"], language[current_language]["Settings"]["card4_title"],  language[current_language]["Settings"]["card6_title"], language[current_language]["Settings"]["card5_title"]];
       description = [language[current_language]["Settings"]["card1_subtitle"], language[current_language]["Settings"]["card4_subtitle"], language[current_language]["Settings"]["card6_subtitle"], language[current_language]["Settings"]["card5_subtitle"]];
       super.initState();
     }

     @override
     Widget build(BuildContext context){
     return Scaffold(
       backgroundColor: colores[mode_counter],

     );
   }
   }