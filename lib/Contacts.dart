import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'Dialer.dart';
import 'package:path_provider/path_provider.dart';
import 'ManageMap.dart';
import 'package:restart_app/restart_app.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_downloader/image_downloader.dart';


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
  late String historyDate;
  String myBackupFile = "";
  String myBackupDir = "";
  String? myJsonBackup = "";
  DateTime now = DateTime.now();
  String path = "";
  late List<PlatformFile> files;
  String image = "";
  var imagePath;

  _ContactState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.history);

  var filePath = 'assets/contacts.json';
  var contactos = ["Example"];
  var telefonos = ["123"];
  var photos = ["/sdcard"];
  bool _fileExists = false;
  late File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<dynamic, dynamic> mapa = {};
  Map<dynamic, dynamic> images = {};
  String jsonFile = "languages.json";

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
    return File('$path/$jsonFile');
  }

  // Write latest key and value to json
  void _writeJson(String key, dynamic value, String type) async {
    final filePath = await _localFile;


    if (jsonFile.contains("contacts.json")) {
      Map<String, dynamic> _newJson = {};

      if (type.contains("contact")) {
        _newJson[key] = value;
      }

      mapa.addAll(_newJson);
      print(mapa);
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);
    }

    else if (jsonFile.contains("history.json")) {
      Map<String, dynamic> _newJson = {key : value};
      history.addAll(_newJson);
      _jsonString = jsonEncode(history);
      filePath.writeAsString(_jsonString);

    }

  }


  // Read json and update the lists on runtime
  void _readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        if (jsonFile.contains("contacts.json")) {
          _jsonString = await _filePath.readAsString();
          mapa = jsonDecode(_jsonString);

        } else if (jsonFile.contains("history.json")) {
          _jsonString = await _filePath.readAsString();
          history = jsonDecode(_jsonString);
        }
      } catch (e) {

      }
    }
    setState(() {
      contactos = addContactsToList(mapa, contactos, telefonos);
      telefonos = addPhonesToList(mapa, contactos, telefonos);
      photos =  addPhotosToList(mapa, contactos, telefonos, photos);
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
      photos = [];
      _readJson();
    });
  }

  // Add contacts entries to lists
  List<String> addContactsToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos) {

    for(String number in dic.keys){
        if (telefonos.contains(number) == false) {
          contactos.add(dic[number][0]);
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

  // Add photos entries to lists
  List<String> addPhotosToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos, List<String> photos){

    for(String number in dic.keys){
      if (dic.isNotEmpty) {
        photos.add(dic[number][1]);
      }

    }
    print(telefonos[0]);
    print(contactos[0]);
    print(dic[telefonos[0]][1]);
    print(photos);

    return photos;
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

  void exportSingleContact(String path, String contact) async {

    // Set file path
    File myContact = File("$path/$contact.json");

    // Save map into variable
    final jsonFile = jsonEncode(mapa);

    // Write file
    myContact.writeAsString(jsonFile);

    setState(() async {
      myBackupFile = language[current_language]["Contacts"]["export"] + "\n" + myContact.path;

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

  void pickImage(String number, String name) async {
    bool exists = false;

    // User can choose a file from storage
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif'],
      allowMultiple: false,
    );


    // Check if the user closed the file picker
    if (result != null) {
      PlatformFile myFile = result.files.first;
      exists = true;


      if (exists) {
        setState(() async {
          path = myFile.path!;

          // Check image extensions

          if (path.contains('.png')){
            await File(path).rename(
                '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.png');
            image = '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.png';

          }  else if (path.contains('.jpg')){
            await File(path).rename(
                '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.jpg');
            image = '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.jpg';
          } else {
            await File(path).rename(
                '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.gif');
            image =
            '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.gif';
          }

            jsonFile = "contacts.json";
          _writeJson(number, [name, image], "contact");
          mapa[number] = [name, image];
        });
      }
    }
  }
  
  void readBackup(File myBackup) async{

    Map<dynamic, dynamic> myTempMap = {};

    setState(() async {

      // Save file content as string
      _jsonString = await myBackup.readAsString();

      // Decode string into a map
      myTempMap = jsonDecode(_jsonString);

      // Save only new keys
      for (String key in myTempMap.keys){
        if(mapa.containsKey(key) == false){
          mapa[key] = myTempMap[key];
        }
      }

      // Overwrite internal map as always
      final filePath = await _localFile;
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);

      // Update lists with new internal map
      mapa = jsonDecode(_jsonString);
      contactos = addContactsToList(mapa, contactos, telefonos);
      telefonos = addPhonesToList(mapa, contactos, telefonos);
      photos =  addPhotosToList(mapa, contactos, telefonos, photos);
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

  void createContactView(String number, String name, String picture, int index) async {

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: colores[mode_counter],
                  content: SingleChildScrollView(
                      child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              minRadius: 50,
                              maxRadius: 75,
                              backgroundColor: Colors.transparent,
                              child : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(File(
                                  mapa[telefonos[index]][1],
                                ),
                                    fit: BoxFit.fill
                                ),
                              ),
                            ),

                            ElevatedButton(
                              child: Text(
                                language[current_language]["EditContact"]["image"],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(color: Colors.white),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              onPressed: () async {

                                setState(() async {
                                  if (phone.text.isEmpty){
                                    pickImage(number, name);
                                  } else {
                                    pickImage(phone.text, name);
                                  }
                                  Navigator.pop(context);
                                });

                              },
                            ),

                            SizedBox(height: 20,),

                            Row(
                                children: [
                                  Text(language[current_language]["EditContact"]["input1"], style: TextStyle(
                                      color: Colors.white),),
                                ]
                            ),

                            SizedBox(height: 10,),

                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                  ),

                                  labelText: name,
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  )

                              ),
                              controller: contact,
                            ),

                            SizedBox(height: 10,),

                            Row(
                                children: [
                                  Text(language[current_language]["EditContact"]["input2"], style: TextStyle(
                                      color: Colors.white),),
                                ]
                            ),

                            SizedBox(height: 10,),

                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                  ),

                                  labelText: number,
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  )

                              ),
                              controller: phone,
                            ),

                            SizedBox(height: 30,),

                            Column(
                                children: <Widget>[
                                  ElevatedButton(
                                    child: Text(
                                      language[current_language]["EditContact"]["button1"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.black),
                                      backgroundColor: Colors.green,
                                      fixedSize: const Size(340, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      jsonFile = "history.json";
                                      _readJson();
                                      _writeJson(number, historyDate, "");
                                      llamar(telefonos, index);
                                      Navigator.pop(context);

                                      // Reset form values
                                      phone.text = "";
                                      contact.text = "";
                                    },
                                  ),

                                  SizedBox(height: 10,),

                                  ElevatedButton(
                                    child: Text(
                                      language[current_language]["EditContact"]["button2"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.black),
                                      backgroundColor: Colors.orange,
                                      fixedSize: const Size(340, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (contact.text.contains(name) ) {
                                        if (phone.text.contains(number)) {
                                          jsonFile = "contacts.json";
                                          _readJson();
                                          _writeJson(number, [name, mapa[number][1]], "contact");
                                          Navigator.pop(context);
                                        } else {
                                          if (phone.text.isEmpty){
                                            jsonFile = "contacts.json";
                                            _readJson();
                                            _writeJson(number, [contact.text, mapa[number][1]], "contact");
                                            mapa.remove(number);
                                            removePhone(mapa);
                                            Navigator.pop(context);
                                          } else {
                                            jsonFile = "contacts.json";
                                          _readJson();
                                          _writeJson(phone.text, [contact.text, mapa[number][1]], "contact");
                                          mapa.remove(number);
                                          removePhone(mapa);
                                          Navigator.pop(context);
                                          }
                                      }

                                      } else {
                                        if (contact.text.isEmpty &&
                                            phone.text.isEmpty) {
                                          jsonFile = "contacts.json";
                                          _readJson();
                                          _writeJson(number, [name, mapa[number][1]], "contact");
                                          Navigator.pop(context);
                                        } else if (phone.text.isEmpty) {
                                          jsonFile = "contacts.json";
                                          _readJson();
                                          _writeJson(number, [contact.text, mapa[number][1]], "contact");
                                          mapa.remove(number);
                                          removePhone(mapa);
                                          Navigator.pop(context);

                                          } else if (contact.text.isEmpty){
                                          jsonFile = "contacts.json";
                                          _readJson();
                                          _writeJson(phone.text, [name, mapa[number][1]], "contact");
                                          mapa.remove(number);
                                          removePhone(mapa);
                                          Navigator.pop(context);
                                        } else {
                                          jsonFile = "contacts.json";
                                          _readJson();
                                          _writeJson(phone.text, [contact.text, mapa[number][1]], "contact");
                                          mapa.remove(number);
                                          removePhone(mapa);
                                          Navigator.pop(context);

                                        }
                                      }

                                      // Reset form values
                                      phone.text = "";
                                      contact.text = "";
                                    },
                                  ),

                                  SizedBox(height: 10,),

                                  ElevatedButton(
                                    child: Text(
                                      language[current_language]["EditContact"]["button3"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.black),
                                      backgroundColor: Colors.red,
                                      fixedSize: const Size(340, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      mapa.remove(number);
                                      setState(() {
                                        removePhone(mapa);
                                        Navigator.pop(context);

                                        // Reset form values
                                        phone.text = "";
                                        contact.text = "";
                                      });
                                    },
                                  ),

                                  SizedBox(height: 10,),

                                  ElevatedButton(
                                    child: Text(
                                      language[current_language]["EditContact"]["button4"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.black),
                                      backgroundColor: Colors.black,
                                      fixedSize: const Size(340, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        pickDirectory();
                                        exportSingleContact(myBackupDir, name);
                                      });
                                    },
                                  ),

                                  SizedBox(width: 15,),
                                ]

                            )


                          ]
                      )
                  ),

                );
              }
          );
        });
  }

  @override
  void initState(){
    if(contactos.contains("Example") && telefonos.contains("123")) {
      contactos.remove("Example") && telefonos.remove("123");

    }
    jsonFile = "contacts.json";
    _readJson();
    number = "";
    name = "";
    contactos = addContactsToList(mapa, contactos, telefonos);
    telefonos = addPhonesToList(mapa, contactos, telefonos);
    formattedDate = DateFormat('yyyy_MM_dd' ).format(now);
    historyDate = DateFormat('EEE d MMM' ).format(now);

    setState(() async {

      if (await File('sdcard/download/profile.png').exists() == false){
        var image =  await ImageDownloader.downloadImage("https://raw.githubusercontent.com/daviiid99/Material_Dialer/google_play/assets/images/anonymous.png");
        imagePath = await ImageDownloader.findPath(image);
        await File(imagePath).rename('sdcard/download/profile.png');
        imagePath = 'sdcard/download/profile.png';

      } else {
        imagePath = 'sdcard/download/profile.png';
      }


    });

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
        FittedBox(
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
                child: FittedBox(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                                           setState(() async {
                                             if(phone.text.length > 0) {
                                               List<String> lista = [contact.text, imagePath];
                                               mapa[phone.text] = lista;
                                               contactos = addContactsToList(
                                                   mapa, contactos, telefonos);
                                               telefonos = addPhonesToList(
                                                   mapa, contactos, telefonos);
                                               jsonFile = "contacts.json";
                                               _writeJson(
                                                   phone.text, [contact.text, "$imagePath"], "contact");
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
                      ), SizedBox(width: 10,),
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
                            setState(()  {
                              List<String> lista = [name, imagePath];
                              mapa[number] = lista;
                              contactos = addContactsToList(mapa, contactos, telefonos);
                              telefonos = addPhonesToList(mapa, contactos, telefonos);
                              photos = addPhotosToList(mapa, contactos, telefonos, photos);
                              jsonFile = "contacts.json";
                              _writeJson(number, lista, "contact");
                            });
                          };
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(language[current_language]["Contacts"]["toaster"] + "\n" + name + "(" + number+ ")"),
                          ));
                        },
                        icon: Icon(Icons.add_rounded, color: Colors.black,),
                      ),
                    ]))
        ),

        ),if(contactos.length == 0) Image.asset("assets/images/empty.png") ,
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
            leading:  CircleAvatar(
              backgroundColor: Colors.transparent,
              child: SizedBox(
              width: 60,
              height: 60,
              child: ClipOval(
              child: Image.file(File(
                   mapa[telefonos[index]][1],
                 ),
                  fit: BoxFit.fitHeight
                ),
               ),
            ),
            ),
                  onTap: () {
                    createContactView(telefonos[index], contactos[index],  photos[index], index);

                  },
            title: Text(contactos[index]),
            subtitle: Text(telefonos[index]),
            ));
        },
      ),

    )]));
  }
}