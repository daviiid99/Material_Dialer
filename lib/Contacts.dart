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
import 'ManageMap.dart';
import 'package:restart_app/restart_app.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class Contacts extends StatefulWidget{
   @override
   // Recover theme styles
   int mode_counter = 1;
   List<IconData> modes = [];
   List<Color> colores = [];
   List<Color> fonts  = [];
   String current_language = "";
   Map<dynamic, dynamic> language = {};
   Map<dynamic, dynamic> history = {};
   Contacts(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.history);
   double fontsize = 55;

   _ContactState createState() => _ContactState(mode_counter, modes, colores, fonts, current_language, language, history);
}


class _ContactState extends State<Contacts>{

  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  String current_language = "";
  final phone = TextEditingController();
  final contact = TextEditingController();
  var map = ManageMap();
  Map<dynamic, dynamic> language = {};
  Map<dynamic, dynamic> history = {};
  late String formattedDate;
  String myBackupFile = "";
  String myBackupDir = "";
  String? myJsonBackup = "";
  DateTime now = DateTime.now();
  String path = "";
  late List<PlatformFile> files;

  _ContactState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.history);

  var filePath = 'assets/contacts.json';
  var contactos = ["Example"];
  var telefonos = ["123"];
  bool _fileExists = false;
  late File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<dynamic, dynamic> mapa = {};
  late String _jsonString;
  String data = "";

  // Get app local path for App data
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get file object with full path
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contacts.json');
  }

  // Write latest key and value to json
  void _writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    mapa.addAll(_newJson);
    _jsonString = jsonEncode(mapa);
    filePath.writeAsString(_jsonString);
  }

  // Read json and update the lists on runtime
  void _readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        _jsonString = await _filePath.readAsString();
        mapa = jsonDecode(_jsonString);
      } catch (e) {

      }
    }
    setState(() {
      contactos = addContactsToList(mapa, contactos, telefonos);
      telefonos = addPhonesToList(mapa, contactos, telefonos);
    });
  }

  void llamar(List<String> telefonos, index) async{
    String number = "tel:${telefonos[index]}";
    await FlutterPhoneDirectCaller.callNumber(number);
  }


  removePhone(Map<dynamic,dynamic> mapa) {
    setState(() async {
      final filePath = await _localFile;
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);
      contactos = [];
      telefonos = [];
      _readJson();
    });
  }

  // Add contacts entries to lists
  List<String> addContactsToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos){

    for(String key in dic.keys){
        if(telefonos.contains(key) == false){
          contactos.add(dic[key]);
        }
      }

    return contactos;
  }


  // Add phones entries to lists
  List<String> addPhonesToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos){

    for(String key in dic.keys){
        if(telefonos.contains(key) == false){
          telefonos.add(key);
      }
    }

    return telefonos;
  }

void exportContacts(String path) async{
    // Set path
    File backup = File("$path/material_dialer_backup_$formattedDate.json");

    // Write file string
    final jsonFile = jsonEncode(mapa);

    // Save the file into directory
    backup.writeAsString(jsonFile);

    setState(() async {
      myBackupFile = language[current_language]["Contacts"]["export"] + "\n" + backup.path;

      });
  }

  void pickDirectory() async{
    // Set user path for downloading the file later
    String? myDirectory = await FilePicker.platform.getDirectoryPath();

    // Check if the user closed the file picker
    if (myDirectory == null){
      setState(() {
        myBackupDir = "empty";

      });
    } else {
      myBackupDir = myDirectory;
    }
  }

  void pickFile() async {
    bool exists = false;

    // User can choose a file from storage
     final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );


    // Check if the user closed the file picker
    if (result != null) {
      PlatformFile myFile = result.files.first;
      exists = true;


      if (exists) {
        setState(() async {
          path = myFile.path!;
          await File(path).rename(
              '/data/user/0/com.daviiid99.material_dialer/app_flutter/backup.json');
          path = await _localPath;
          readFile();
        });
      }
    }
  }
  
  void readBackup(File myBackup) async{

    setState(() async {
      _jsonString = await myBackup.readAsString();
      mapa = jsonDecode(_jsonString);
      final filePath = await _localFile;
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);
      contactos = addContactsToList(mapa, contactos, telefonos);
      telefonos = addPhonesToList(mapa, contactos, telefonos);
    });
    
  }

  void readFile() async {

    // Create a new File using backup path
    File myBackup = File('/data/user/0/com.daviiid99.material_dialer/app_flutter/backup.json');

    // Read backup content
    readBackup(myBackup);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: language[current_language]["Contacts"]["import"],
    ));


  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }



  List colors = [Colors.blue, Colors.red,Colors.yellow, Colors.green];

  late String name, number;
  final FlutterContactPicker contactPicker = new FlutterContactPicker();

  @override
  void initState(){
    if(contactos.contains("Example") && telefonos.contains("123")) {
      contactos.remove("Example") && telefonos.remove("123");

    }
    _readJson();
    number = "";
    name = "";
    contactos = addContactsToList(mapa, contactos, telefonos);
    telefonos = addPhonesToList(mapa, contactos, telefonos);
    formattedDate = DateFormat('yyyy_MM_dd' ).format(now);
    super.initState();
  }

  @override
  Widget build(BuildContext context){


    return Scaffold(
      backgroundColor: colores[mode_counter],
      appBar: AppBar(
        backgroundColor: colores[mode_counter],
        title: Text(language[current_language]["Contacts"]["title"],
          style: TextStyle(color: fonts[mode_counter]),

        ),
        actions: [
          PopupMenuButton(
            color: colores[mode_counter],
            itemBuilder: (context){
              return[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                   language[current_language]["Contacts"]["menu_button"],
                    style: TextStyle(color:  Colors.white),

                  ),
                ),

                PopupMenuItem(
                  value: 1,
                  child: Text(
              language[current_language]["Contacts"]["menu_button_2"],
                      style: TextStyle(color:  Colors.white)),
                ),
              ];

            },

            onSelected: (value) async {
              if(value == 0){
                pickFile();

              }

              else if ( value == 1){
                pickDirectory(); // User can pick a dir
                if (myBackupDir == null){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("User cancelled the operation :("),
                ));
                } else{
                exportContacts(myBackupDir);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$myBackupFile"),
                ));

                }

              }
            }
          )
        ],
        iconTheme: IconThemeData(
          color: fonts[mode_counter], //change your color here
        ),
    ),
    body: Column(
      children: <Widget>[
      Text("\n"),
      Image.asset('assets/images/contacts.png'),
        Container(
            child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 6,
                color: colores[mode_counter],
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(width: 18,),
                      TextButton.icon(
                        label: Text(
                          language[current_language]["Contacts"]["button1"],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(color: Colors.black),
                          backgroundColor: Colors.green,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: () {
                         showDialog(
                           context: context,
                           builder: (BuildContext context){
                             return AlertDialog(
                               backgroundColor: Colors.lightGreen,
                               content: SingleChildScrollView(
                                 child: Column(
                                     children: <Widget>[
                                       Text("\n"),
                                       TextFormField(
                                         controller: phone,
                                         keyboardType: TextInputType.phone,
                                         decoration:  InputDecoration(
                                           border: OutlineInputBorder(),
                                           labelText: language[current_language]["CreateContact"]["box1"],
                                         ),
                                       ),
                                       Text("\n"),

                                       TextFormField(
                                         controller: contact,
                                         decoration: InputDecoration(
                                           border: OutlineInputBorder(),
                                           labelText: language[current_language]["CreateContact"]["box2"],
                                         ),
                                       ),

                                       Text("\n\n\n"),

                                       TextButton.icon(
                                         label:  Text(
                                           language[current_language]["CreateContact"]["button"],
                                           style: TextStyle(
                                               fontSize: 16,
                                               color: Colors.black),
                                         ),
                                         style: TextButton.styleFrom(
                                           textStyle: TextStyle(color: Colors.black),
                                           backgroundColor: Colors.green,
                                           shape:RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(24.0),
                                           ),
                                         ),
                                         onPressed: () {
                                           setState(() {
                                             if(phone.text.length > 0) {
                                               mapa[phone.text] = contact.text;
                                               contactos = addContactsToList(
                                                   mapa, contactos, telefonos);
                                               telefonos = addPhonesToList(
                                                   mapa, contactos, telefonos);
                                               _writeJson(
                                                   phone.text, contact.text);
                                               Navigator.pop(context);
                                             ScaffoldMessenger.of(context)
                                                 .showSnackBar(SnackBar(
                                               content: Text(
                                                   language[current_language]["CreateContact"]["toaster"] +
                                                       "\n" + contact.text +
                                                       "(" + phone.text + ")"),
                                             ));
                                               contact.text = "";
                                               phone.text = "";
                                             }
                                           });

                                         },
                                         icon: Icon(Icons.save_rounded, color: Colors.black,),
                                       )
                                     ]
                                 ),
                               )
                             );
                           }

                         );
                        },
                        icon: Icon(Icons.create_rounded, color: Colors.black,),
                      ), const SizedBox(width: 25,),
                      TextButton.icon(
                        label: Text(
                          language[current_language]["Contacts"]["button2"],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(color: Colors.black),
                          backgroundColor: Colors.orange,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: () async {
                          Contact? contact = await contactPicker.selectContact();
                          if (contact !=null){
                            number = contact.phoneNumbers![0];
                            name = contact.fullName.toString();
                            setState(() {
                              mapa[number] = name;
                              contactos = addContactsToList(mapa, contactos, telefonos);
                              telefonos = addPhonesToList(mapa, contactos, telefonos);
                              _writeJson(number, name);
                            });
                          };
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(language[current_language]["Contacts"]["toaster"] + "\n" + name + "(" + number+ ")"),
                          ));
                        },
                        icon: Icon(Icons.add_rounded, color: Colors.black,),
                      ),  const SizedBox(width: 18,),
                    ]))
        ),

        if(contactos.length == 0) Image.asset("assets/images/empty.png") ,
        if(contactos.length == 0) Text(language[current_language]["Contacts"]["empty"],
            style: TextStyle(color: fonts[mode_counter], fontSize: 20)) ,

      Expanded(
    child : ListView.builder(
        itemCount: contactos.length,
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
                  MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colores, fonts, current_language, language, telefonos[index], history)),
                );
              },
            ),
                  onTap: () {

                  },
            title: Text(contactos[index]),
            subtitle: Text(telefonos[index]),
            trailing: IconButton(
              icon : const Icon(Icons.remove_circle, color: Colors.redAccent,),
              onPressed: (){
                mapa.remove(telefonos[index]);
                setState(() {
                  removePhone(mapa);
                });
              },

          )));
        },
      ),

    )]));
  }
}