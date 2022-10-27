import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'DialPadNumbers.dart';
import 'Dialer.dart';
import 'package:path_provider/path_provider.dart';


class History extends StatefulWidget{
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  History(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language);
  _HistoryState createState() => _HistoryState(mode_counter, modes, colores, fonts, current_language, language);
}

class _HistoryState extends State<History>{
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  Map<dynamic, dynamic> history = {};
  bool _fileExists = false;
  late File _filePath;
  String _jsonString = "";
  List<String> numeros = [];
  List <String> fechas = [];
  _HistoryState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language);

  // Get app local path for App data
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

// Get file object with full path
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/history.json');
  }

  List<String> addNumero(Map<dynamic, dynamic> history, List<String> numeros){

    for(String key in history.keys){
      if(numeros.contains(key) == false) numeros.add(key);
    }
    return numeros;
  }

  List<String> addFecha(Map<dynamic, dynamic> history, List<String> fechas, List<String> numeros){

    for (String key in history.keys){
      if (numeros.contains(key)){
        fechas.add(history[key]);
        }
      }

    return fechas;

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

      setState(() {
        numeros = addNumero(history, numeros);
        fechas = addFecha(history, fechas, numeros);
      });
    }
  }

  removePhone(Map<dynamic,dynamic> mapa) {
    setState(() async {
      final filePath = await _localFile;
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);
      fechas = [];
      numeros = [];
      _readJson();
    });
  }

  @override
  void initState(){
    _readJson();
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: colores[mode_counter],
    appBar: AppBar(
      backgroundColor: colores[mode_counter],
      title: Text(
        language[current_language]["History"]["title"],
        style: TextStyle(color: fonts[mode_counter]),
      ),
      iconTheme: IconThemeData(
        color: fonts[mode_counter], //change your color here
      ),
    ),

      body: Column(
        children: <Widget>[
          Text("\n"),
          Image.asset('assets/images/history.png'),
          Text("\n\n"),
          Text(
              language[current_language]["History"]["subtitle"],
          style: TextStyle(color: fonts[mode_counter], fontSize: 35),

          ),

          if(numeros.length == 0) Image.asset("assets/images/empty.png") ,
          if(numeros.length == 0) Text(language[current_language]["Contacts"]["empty"],
              style: TextStyle(color: fonts[mode_counter], fontSize: 20)) ,
        Expanded(
          child : ListView.builder(
            itemCount: numeros.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  tileColor: colores[mode_counter] ,
                  textColor: fonts[mode_counter],
                  leading: IconButton(
                    icon: const Icon(Icons.call, color: Colors.blueAccent,),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colores, fonts, current_language, language, numeros[index], history)),
                      );
                    },
                  ),
              onTap: () {

              },
              title: Text(numeros[index]),
              subtitle: Text(fechas[index]),
              trailing: IconButton(
              icon : const Icon(Icons.remove_circle, color: Colors.redAccent,),
              onPressed: (){
                history.remove(numeros[index]);
                setState(() {
                  removePhone(history);
                });
              },
                ),


              ));
            }

          )
          )
        ],
        ),
      );
  }
}