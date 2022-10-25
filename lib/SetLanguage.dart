import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'MaterialDIaler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ManageMap.dart';
import 'Settings.dart';
import 'package:restart_app/restart_app.dart';

class SetLanguage extends StatefulWidget{
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  SetLanguage(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language);
  _SetLanguageState createState() => _SetLanguageState(mode_counter, modes, colores, fonts, current_language, language);
}

class _SetLanguageState extends State<SetLanguage>{
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  List<String> languages = ["Deutsch", "Español", "English", "Français", "Italiano"];
  _SetLanguageState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language);

  String jsonFile = "languages.json";
  late String _jsonString;

  // Get app local path for App data
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

// Get file object with full path
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$jsonFile');
  }

  // Write latest key and value to json
  void writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    language.addAll(_newJson);
    _jsonString = jsonEncode(language);
    filePath.writeAsString(_jsonString);
  }

  @override
  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:  colores[mode_counter],
      appBar: AppBar(
        leading: Icon(Icons.language_rounded, color: Colors.blueAccent),
        backgroundColor: colores[mode_counter],
        title: Text (
            language[current_language]["Country"]["title"],
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

                      setState(() {
                        writeJson("language",languages[index]);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(language[current_language]["Country"]["toaster"] + languages[index]),
                      ));

                      Restart.restartApp();


                      },

            ));} ));
  }
}