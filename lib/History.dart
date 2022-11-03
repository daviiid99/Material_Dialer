import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'Dialer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';


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
  String myBackupDir = "sdcard/download";
  DateTime now = DateTime.now();
  String date = "";
  String path = "";
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

  void llamar(List<String> telefonos, index) async{
    String number = "tel:${telefonos[index]}";
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  cleanHistory() {

    setState(() async {
      // Write empty map
      final filePath = await _localFile;

      // Write empty string
      Map<dynamic, dynamic> mapa = {};
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);

      // Reload JSON file
      fechas = [];
      numeros = [];
      _readJson();
    });

  }

  exportHistory() async {

    // Save current file to string
    _jsonString = jsonEncode(history);

    // Choose dir
    await setDir();

    // Write file
    File("$myBackupDir/backup_$date.json").writeAsString(_jsonString);

    //Notify user of the export
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Exported file\n$myBackupDir/backup_$date.json"),
    ));

  }

  setDir() async {
    // Choose dir
    String? dir = await FilePicker.platform.getDirectoryPath();

    // Check if the user selected a dir and assign it
    if (dir != null){
      myBackupDir = dir;
    }
  }

  importHistory() async {

    // Choose the file
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: false
    );

    // Save the file into an internal storage location
    if (file != null){
      PlatformFile myfile = file.files.first;

      // Get temp file path
      String path = myfile.path!;

      // Save to internal
      await File(path).rename("/data/user/0/com.daviiid99.material_dialer/app_flutter/myhistory.json");

      // Save file path into a global variable
      this.path = "/data/user/0/com.daviiid99.material_dialer/app_flutter/myhistory.json";

      // Import files
      Map<dynamic, dynamic> myOldHistory = {}; // Temp map

      _jsonString = await File(this.path).readAsString(); // Read input file as string and save it

      myOldHistory = jsonDecode(_jsonString); // Decode the map file into a map object

      // Add keys and values into current map
      for (String key in myOldHistory.keys){
        if (numeros.contains(key) == false){
          history[key] = myOldHistory[key];
        }

      }
      // Override map
      _jsonString = jsonEncode(history); // Save map to string
      final filePath = await _localFile; // Get map path
      filePath.writeAsString(_jsonString); // Write map

      // Reload JSON file
      _readJson();

    }
  }

  @override
  void initState(){
    // Set full screen mode for an inmersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    date = DateFormat('yyyy_MM_dd' ).format(now);
    _readJson();
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: colores[mode_counter],
    appBar: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      backgroundColor: colores[mode_counter],
      iconTheme: IconThemeData(
        color: fonts[mode_counter], //change your color here
      ),
    ),

      body: Column(
        children: <Widget>[
          Image.asset('assets/images/history.png'),
          Text(
              language[current_language]["History"]["subtitle"],
          style: TextStyle(color: fonts[mode_counter], fontSize: 30, fontWeight: FontWeight.bold),

          ),
          if(numeros.length == 0) Image.asset("assets/images/empty.png", width: 800, height: 300,) ,

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
                     llamar(numeros, index);
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
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: colores[mode_counter],
        unselectedItemColor: fonts[mode_counter],
        selectedItemColor: fonts[mode_counter],

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                alignment: Alignment.bottomLeft,
                icon: Icon(Icons.import_contacts_rounded),
                onPressed: (){
                  importHistory();
                },
              )
          ),

          BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                alignment: Alignment.bottomCenter,
                icon: Icon(Icons.ios_share_rounded),
                onPressed: (){
                  exportHistory();
                },
              )
          ),

          BottomNavigationBarItem(
              label: '',
              icon: IconButton(
                alignment: Alignment.bottomRight,
                icon: Icon(Icons.delete_rounded),
                onPressed: (){
                  cleanHistory();
                },
              )
          )
        ],
      ),
      );
  }
}