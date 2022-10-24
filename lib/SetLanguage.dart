import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'dart:convert';
import 'dart:io';
import 'MaterialDIaler.dart';
import 'package:url_launcher/url_launcher.dart';

class SetLanguage extends StatefulWidget{
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  SetLanguage(this.mode_counter, this.modes, this.colores, this.fonts);
  _SetLanguageState createState() => _SetLanguageState(mode_counter, modes, colores, fonts);
}

class _SetLanguageState extends State<SetLanguage>{
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  List<String> languages = ["中国人", "Deutsch", "Español", "English", "Français", "Italiano", "日本"];

  _SetLanguageState(this.mode_counter, this.modes, this.colores, this.fonts);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:  colores[mode_counter],
      appBar: AppBar(
        leading: Icon(Icons.language_rounded, color: Colors.blueAccent),
        backgroundColor: colores[mode_counter],
        title: Text(
            "Set Your Language",
          style: TextStyle(color: fonts[mode_counter]),

        ),
        iconTheme: IconThemeData(
          color: fonts[mode_counter], //change your color here
        ),
      ),
        body: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    tileColor: colores[mode_counter] ,
                    textColor: fonts[mode_counter],
                    title: Text(languages[index]),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Default language set to : " + languages[index]),
                      ));
                    } ));},)
    );
  }
}