import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'ManageMap.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class DialPadNumbers extends StatefulWidget {
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  late String number;
  Map<dynamic, dynamic> history = {};
  DialPadNumbers(this.mode_counter, this.modes, this.colors, this.fonts, this.current_language, this.language, this.number, this.history);
  _DialPadNumberState createState() => _DialPadNumberState(mode_counter, modes, colors, fonts, current_language, language, number, history);
}

class _DialPadNumberState extends State<DialPadNumbers>{

  // Recover theme styles
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  late String number;
  Map<dynamic, dynamic> history = {};
  String jsonFile = "history.json";
  late String formattedDate;
  DateTime now = DateTime.now();
  final player = AudioPlayer();
  _DialPadNumberState(this.mode_counter, this.modes, this.colors, this.fonts, this.current_language, this.language, this.number, this.history);
  double fontsize = 55;

  bool _fileExists = false;
  late File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<dynamic, dynamic> mapa = {};
  late String _jsonString;
  String data = "";

  void llamar(String telefono) async{
    await FlutterPhoneDirectCaller.callNumber("$telefono");
  }


  // TO-DO
  //void _navigateToNextScreen(BuildContext context) {
  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => llamar()));
  // }

  String addNumber(String numero, String full){
    if(full.length == 3) {
      full += " ";
    }
    else if(full.length == 6){
      full += " ";
    } else if (full.length == 9){
      full += " ";
    }
    return full += numero;
  }

  double checkFont(String numero, double font){

    if(numero.length == 5){
      font -= 5;
    } else if (numero.length == 8) {
      font -= 5;
    } else if (numero.length > 8 && font > 45){
      font = 45;
    }  else if (numero.length == 1) {
      font == 55;
    } else if (numero.length > 12){
      font = 25;
    }

    return font;

  }

  String removeCharacter(String numero){
    var str = "";
    str = numero.substring(0, numero.length - 1);
    return str ;
  }

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

  void _readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        _jsonString = await _filePath.readAsString();
        history = jsonDecode(_jsonString);
      } catch (e) {

      }
    }
  }

  // Write latest key and value to json
  void writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    history.addAll(_newJson);
    _jsonString = jsonEncode(history);
    filePath.writeAsString(_jsonString);
    print(_jsonString);
  }


  @override
  void initState(){
    _readJson();
    if (number.length > 12) fontsize = 25;
    _readJson();
    formattedDate = DateFormat('EEE d MMM').format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Column(
        children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 6,
            color: colors[mode_counter],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 45, height: 50,),
                Text(number, style: TextStyle(fontSize: fontsize,
                    color: fonts[mode_counter], decorationColor: colors[mode_counter]
                ))],
            ),
          ), Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 6,
            color: colors[mode_counter],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("1"), focusColor: fonts[mode_counter],
                      onPressed: () {
                        player.play(AssetSource('sounds/1.mp3'));

                        setState(() {
                          number = addNumber("1", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("2"),
                      onPressed: () {
                        player.play(AssetSource('sounds/2.mp3'));
                        setState(() {
                          number = addNumber("2", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("3"),
                      onPressed: () {
                        player.play(AssetSource('sounds/3.mp3'));
                        setState(() {
                          number = addNumber("3", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 23.5,),
              ],
            ),
          ), Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 6,
            color: colors[mode_counter],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("4"),
                      onPressed: () {
                        player.play(AssetSource('sounds/4.mp3'));
                        setState(() {
                          number = addNumber("4", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("5"),
                      onPressed: () {
                        player.play(AssetSource('sounds/5.mp3'));
                        setState(() {
                          number = addNumber("5", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("6"),
                      onPressed: () {
                        player.play(AssetSource('sounds/6.mp3'));
                        setState(() {
                          number = addNumber("6", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 23.5,),
              ],
            ),
          ), Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 6,
            color: colors[mode_counter],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("7"),
                      onPressed: () {
                        player.play(AssetSource('sounds/7.mp3'));
                        setState(() {
                          number = addNumber("7", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("8"),
                      onPressed: () {
                        player.play(AssetSource('sounds/8.mp3'));
                        setState(() {
                          number = addNumber("8", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("9"),
                      onPressed: () {
                        player.play(AssetSource('sounds/9.mp3'));
                        setState(() {
                          number = addNumber("9", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 23.5,),
              ],
            ),
          ), Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height / 6,
            color: colors[mode_counter],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("+"),
                      onPressed: () {
                        setState(() {
                          number = addNumber("+", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Text("0"),
                      onPressed: () {
                        player.play(AssetSource('sounds/0.mp3'));
                        setState(() {
                          number = addNumber("0", number);
                          fontsize = checkFont(number, fontsize);
                        });
                      },
                    ),
                  ),
                ), const SizedBox(width: 23.5,),
                SizedBox(
                  height: 95.0,
                  width: 95.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.backspace_outlined, color: Colors.white,),
                      onPressed: () {
                        player.play(AssetSource('assets/sounds/del.mp3'));
                        setState(() {
                          number = removeCharacter(number);
                          if (fontsize < 55){
                            fontsize += 3;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 23.5,),
              ],
            ),
          ),
          Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 6,
              color: colors[mode_counter],
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(width: 23.5,),
                    TextButton.icon(
                      label: Text(
                        language[current_language]["Calls"],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(color: Colors.black),
                        backgroundColor: Colors.green,fixedSize: const Size(340, 53),
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () => {llamar(number) ,
                        setState(() {
                          writeJson(number, formattedDate);
                          print(history);
                          number = "";
                        })},
                      icon: Icon(Icons.call, color: Colors.black,),
                    ), const SizedBox(width: 46,),

                  ]))]);
  }
}