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
import 'package:flutter_archive/flutter_archive.dart';
import 'package:image/image.dart' as ImageProcess;


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
  String image = "sdcard/download/profile.png";
  var imagePath;

  _ContactState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language, this.history);

  var filePath = 'assets/contacts.json';
  var contactos = ["Example"];
  var telefonos = ["123"];
  var photos = ["/sdcard"];
  List<String> myBackupFiles = [];
  String internalPath = "/data/user/0/com.daviiid99.material_dialer/app_flutter/";
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
      jsonFile = "contacts.json";
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

    contactos.sort(); // Sort list, you know, alphabetical order

    return contactos;
  }


  // Add phones entries to lists
  List<String> addPhonesToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos){
    for (int i =0; i <contactos.length; i++){
      for (String number in dic.keys){
        if (dic[number][0] == contactos[i]) {
          if ( telefonos.contains(number) == false){
            telefonos.add(number);
          }
        }
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
    return photos;
  }

void exportContacts() async{

    // Write file string
     final jsonFile = jsonEncode(mapa);

    // Await user path
    await pickDirectory();

     // Set path
     // Save the file into directory

     File("$myBackupDir/material_dialer_backup_$formattedDate.json").writeAsString(jsonFile);


    setState(() async {
      myBackupFile = language[current_language]["Contacts"]["export"] + "\n" + File("$myBackupDir/$contact.json").path;

      });
  }

  exportMultipleContacts() async {

    // Await user path
    await pickDirectory();


    for (String key in mapa.keys) {
      setState(() {
        exportSingleContact(mapa[key][0], key, mapa[key][1]);
      });

    }
  }

   exportSingleContact(String contact, String number, String photo) async {

    Map<dynamic, dynamic> myContact = {number : [contact, mapa[number][1]]};

    // Save map into variable
    final jsonFile = jsonEncode(myContact);

    // Image extension
    String extension = "";

    File("/data/user/0/com.daviiid99.material_dialer/app_flutter/$contact.json").writeAsString(jsonFile);

    if (mapa[number][1].contains(".png")){
      extension = ".png";
    } else if (mapa[number][1].contains(".jpg")){
      extension = ".jpg";
    } else if (mapa[number][1].contains(".gif")){
      extension = ".gif";
    }

    // Convert image to base64
    File image = File(mapa[number][1]);
    decodeBase64Image(image, extension, number, "external");


    zipThemAll("$contact.json", "$number$extension");

    // Write file
    setState(() async {
      myBackupFile = language[current_language]["Contacts"]["export"] + "\n" + File("$myBackupDir/$contact.json").path;
    });
  }

  decodeBase64Image(File image, String extension, String number, String path) async {

    final bytes = File(image.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    Uint8List decode64Image = base64Decode(base64Image);

    final myImage = await File("/data/user/0/com.daviiid99.material_dialer/app_flutter/$number$extension").writeAsBytes(decode64Image);

  }

  decodeBase64Zip(File zip, String name ) async {

    setState(() async {
      formattedDate = DateFormat('yyyy_MM_dd_hh_mm_ss').format(now);
    });
    final bytes = zip.readAsBytesSync();
    String base64Zip = base64Encode(bytes);
    Uint8List decode64BitZip = base64Decode(base64Zip);

    final zipFile = await File(myBackupDir + "/$name" + "_$formattedDate.zip").writeAsBytes(decode64BitZip);

  }


  zipThemAll(String pathJson, String pathImage) async {
    // We'll zip all files together

    final dir = Directory("/data/user/0/com.daviiid99.material_dialer/app_flutter"); // Set destinaiton path

    final files = [
      File("/data/user/0/com.daviiid99.material_dialer/app_flutter" + "/$pathJson" ),
      File("/data/user/0/com.daviiid99.material_dialer/app_flutter" + "/$pathImage")
    ]; // Set path for json and image files

    final name = pathJson.replaceAll(".json", "");

    final zipFile = File("/data/user/0/com.daviiid99.material_dialer/app_flutter" + "/$name" + "_"+ "$formattedDate.zip"); // Set final zip file name

    if (await File(zipFile.path).exists()){
      await zipFile.delete();
    }

    try {
      await ZipFile.createFromFiles(
          sourceDir: dir, files: files, zipFile: zipFile);
    } catch (e){
      print(e);
    }

    await decodeBase64Zip(zipFile, name); // Create output zip file
  }

  unZipAll(String pathZip) async {
    final zipPath = File(pathZip); // Zip path
    final outputPath = Directory("/data/user/0/com.daviiid99.material_dialer/app_flutter");
    List<String> files = [];

    try{
      await ZipFile.extractToDirectory(
          zipFile: zipPath, destinationDir: outputPath,
        onExtracting: (zipEntry, progress){
          myBackupFiles.add(zipEntry.name);
              if (zipEntry.name.contains(".json")){
                setState(() async {
                  jsonFile = zipEntry.name;
                  await File("/data/user/0/com.daviiid99.material_dialer/app_flutter/" + jsonFile).exists();
                });

              }
            return ZipFileOperation.includeItem;
        }
      );
    } catch(e){
      print(e);
    }

    try {
      readFile("/data/user/0/com.daviiid99.material_dialer/app_flutter/" + jsonFile);
    } catch (e){


    }

  }

   pickDirectory() async{
    // Set user path for downloading the file later
    String? myDirectory = await FilePicker.platform.getDirectoryPath();

    // Check if the user closed the file picker
    if (myDirectory != null){
      myBackupDir = myDirectory;
    }
  }

   pickFile() async {
    bool exists = false;
    String jsonPath = "";
    List<String> myFiles = [];

    // User can choose a file from storage
     final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: true,
      );

    // Store all files into a list of files
    if (result != null) {
      exists = true;
      List<File> files = result!.paths.map((path) => File(path!)).toList();

      if (exists) {
        setState(() async {
          for (File myFile in files) {
            path = myFile.path!;
            File(path).rename("/data/user/0/com.daviiid99.material_dialer/app_flutter/backup.zip");
            await unZipAll("/data/user/0/com.daviiid99.material_dialer/app_flutter/backup.zip");

            for (String myFile in myBackupFiles){
               if (myFile.contains("..jpg")){
                  myFile.replaceAll("..jpg", "");
                  decodeBase64Image(File(myFile + ".jpg"), ".jpg", myFile,  "internal");
               } if (myFile.contains("..png")){
                  myFile.replaceAll("..png", ".png");
                  decodeBase64Image(File(myFile + ".png"), ".png", myFile, "internal");
                } if (myFile.contains("..gif")){
                  myFile.replaceAll("..gif", ".gif");
                  decodeBase64Image(File(myFile + ".gif"), ".gif", myFile, "internal");
                }
              }
          }
        });
        }
    }

    return 0;
    }

   imageSelector(String number, String name) async {
     bool exists = false;
     String myImage = "";

     // User can choose a file from storage
     final result = await FilePicker.platform.pickFiles(
       type: FileType.custom,
       allowedExtensions: ['jpg', 'png', 'gif'],
       allowMultiple: false,
     );


     // Check if the user closed the file picker
     if (result != null) {
       PlatformFile myFile = await result.files.first;
       exists = true;


       if (exists) {
         path = await myFile.path!;

         setState(() async {
           // Check image extensions

           if (path.contains('.png')) {
             await File(path).rename(
                 '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.png');
             image =
             '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.png';
           } else if (path.contains('.jpg')) {
             await File(path).rename(
                 '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.jpg');
             image =
             '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.jpg';
           } else {
             await File(path).rename(
                 '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.gif');
             image =
             '/data/user/0/com.daviiid99.material_dialer/app_flutter/$number.gif';
           }
         });
       }
     }
     return image;
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
      final filePath = File("/data/user/0/com.daviiid99.material_dialer/app_flutter/contacts.json");
      _jsonString = jsonEncode(mapa);
      filePath.writeAsString(_jsonString);

      // Update lists with new internal map
      mapa = jsonDecode(_jsonString);
      setState(() {
        contactos = [];
        telefonos = [];
        photos = [];
        jsonFile = "contacts.json";
        _readJson();
      });


  }

  void readFile(String pathJson) async {

    // Create a new File using backup path
    File myBackup = File(pathJson);

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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                                    fit: BoxFit.fill,
                                    key: UniqueKey()
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
                                });

                              },
                            ),

                            FittedBox(
                                child: ElevatedButton(
                                  child: Text(
                                      language[current_language]["EditContact"]["refresh_image"]),
                                  onPressed: ()  {
                                    setState(() async {
                                      imageCache.clear();
                                      imageCache.clearLiveImages();
                                      UniqueKey();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,),
                                    backgroundColor: Colors
                                        .lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .circular(24.0),
                                    ),

                                  ),
                                )),

                            SizedBox(height: 20,),

                            Row(
                                children: [
                                  Text(language[current_language]["EditContact"]["input1"], style: TextStyle(
                                      color: Colors.white,  fontWeight: FontWeight.bold),),
                                ]
                            ),

                            SizedBox(height: 10,),

                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
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
                                      color: Colors.white,  fontWeight: FontWeight.bold),),
                                ]
                            ),

                            SizedBox(height: 10,),

                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
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
                                          color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold),
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
                                          color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold),
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
                                          if ( mapa[number][1].contains("png"))  {
                                            await File("$internalPath/$number" + ".png").rename("$internalPath/" + phone.text + ".png");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".png";
                                          }

                                          if ( mapa[number][1].contains("jpg"))  {
                                            await File("$internalPath/$number" + ".jpg").rename("$internalPath/" + phone.text + ".jpg");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".jpg";
                                          }

                                          if ( mapa[number][1].contains("gif"))  {
                                            await File("$internalPath/$number" + ".gif").rename("$internalPath/" + phone.text + ".gif");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".gif";
                                          }

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

                                          if ( mapa[number][1].contains("png"))  {
                                            await File("$internalPath/$number" + ".png").rename("$internalPath/" + phone.text + ".png");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".png";
                                          }

                                          if ( mapa[number][1].contains("jpg"))  {
                                            await File("$internalPath/$number" + ".jpg").rename("$internalPath/" + phone.text + ".jpg");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".jpg";
                                          }

                                          if ( mapa[number][1].contains("gif"))  {
                                            await File("$internalPath/$number" + ".gif").rename("$internalPath/" + phone.text + ".gif");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".gif";
                                          }
                                          _writeJson(phone.text, [name, mapa[number][1]], "contact");
                                          mapa.remove(number);
                                          removePhone(mapa);
                                          Navigator.pop(context);

                                        } else {
                                          jsonFile = "contacts.json";
                                          _readJson();
                                          if ( mapa[number][1].contains("png"))  {
                                            await File("$internalPath/$number" + ".png").rename("$internalPath/" + phone.text + ".png");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".png";
                                          }

                                          if ( mapa[number][1].contains("jpg"))  {
                                            await File("$internalPath/$number" + ".jpg").rename("$internalPath/" + phone.text + ".jpg");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".jpg";
                                          }

                                          if ( mapa[number][1].contains("gif"))  {
                                            await File("$internalPath/$number" + ".gif").rename("$internalPath/" + phone.text + ".gif");
                                            mapa[number][1] = "$internalPath/" + phone.text + ".gif";
                                          }
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
                                          color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      backgroundColor: Colors.black,
                                      fixedSize: const Size(340, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            24.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() async {
                                        // Await user path
                                        await pickDirectory();
                                        exportSingleContact(name, number, picture);
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
    // Set full screen mode for an inmersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    if(contactos.contains("Example") && telefonos.contains("123")) {
      contactos.remove("Example") && telefonos.remove("123");

    }
    jsonFile = "contacts.json";
    _readJson();
    number = "";
    name = "";
    contactos = addContactsToList(mapa, contactos, telefonos);
    telefonos = addPhonesToList(mapa, contactos, telefonos);
    formattedDate = DateFormat('yyyy_MM_dd_hh_mm').format(now);
    historyDate = DateFormat('EEE d MMM' ).format(now);

    setState(() async {
      Uint8List profileImage = await base64Decode("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DquaTvlCymOV8xZnrVhm9XvyFwYz+soy12kNIoZFLEGCCAVlFFCEjQjtOikWEnQebeEfcP0SuRRyFcDIsYASNMiuH/wPfs/Wyk6Me0nBKND+4jgfQ0BgF6hVHOf72HFqJ4D/GbjSG/5SFZj+JL3S0MJHQM82cHHd0JQ94HIH6H8yZFN2JT8tIZsF3s/om9JA3y3QuebNrX6O0wcgSbOK3wAHh8BwjrLXW7y7o3lu//bU5/cDrEByvrF1QMsAAA0aaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJYTVAgQ29yZSA0LjQuMC1FeGl2MiI+CiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIKICAgIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiCiAgICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgICB4bWxuczpHSU1QPSJodHRwOi8vd3d3LmdpbXAub3JnL3htcC8iCiAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgeG1wTU06RG9jdW1lbnRJRD0iZ2ltcDpkb2NpZDpnaW1wOmFmYzRjYjE1LTZmNjctNGVjYy05Y2Y2LTg1ZGY2ODMyMmJlNSIKICAgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo0MmI1ZDk5ZS1hMzNkLTRmZGUtODQzZi1mZTc0NTdiOTEzMGQiCiAgIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo4NjgxNTFiNy1iYjQ0LTQ4ZWQtOTJjNC0xNjc3NmM1NjNkNmYiCiAgIGRjOkZvcm1hdD0iaW1hZ2UvcG5nIgogICBHSU1QOkFQST0iMi4wIgogICBHSU1QOlBsYXRmb3JtPSJMaW51eCIKICAgR0lNUDpUaW1lU3RhbXA9IjE2NjczMjE5MDc3MzE1MjIiCiAgIEdJTVA6VmVyc2lvbj0iMi4xMC4zMCIKICAgdGlmZjpPcmllbnRhdGlvbj0iMSIKICAgeG1wOkNyZWF0b3JUb29sPSJHSU1QIDIuMTAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJzYXZlZCIKICAgICAgc3RFdnQ6Y2hhbmdlZD0iLyIKICAgICAgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpjMTEzYjVjZi0zNDEzLTRlYWMtYTU5ZC00ZjljNDY1Mzk3MzAiCiAgICAgIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkdpbXAgMi4xMCAoTGludXgpIgogICAgICBzdEV2dDp3aGVuPSIyMDIyLTExLTAxVDE3OjU4OjI3KzAxOjAwIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/PuND9fQAAAAGYktHRACHAMAAKrCRiGsAAAAJcEhZcwAAEJwAABCcASbNOjQAAAAHdElN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");

      if (await File('sdcard/download/profile.png').exists() == false){
        try{
          await File('sdcard/download/profile.png').writeAsBytes(profileImage);
          imagePath = 'sdcard/download/profile.png';
        } catch (e){
          imagePath = 'sdcard/download/profile.png';
        }
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
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: colores[mode_counter],
    ),
    body: Column(
      children: <Widget>[
      Image.asset('assets/images/contacts.png'),
        Text(language[current_language]["Contacts"]["title"],
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ),
                          textStyle: TextStyle(color: Colors.white),
                          backgroundColor: Colors.transparent,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      backgroundColor: colores[mode_counter],
                                      content: SingleChildScrollView(
                                        child: Column(
                                            children: <Widget>[
                                              Text("\n"),

                                              CircleAvatar(
                                                minRadius: 50,
                                                maxRadius: 75,
                                                backgroundColor: Colors
                                                    .transparent,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(8.0),
                                                  child: Image.file(
                                                      File(image),
                                                      fit: BoxFit.fill,
                                                    key: UniqueKey(),
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                  child: ElevatedButton(
                                                    child: Text(
                                                        language[current_language]["EditContact"]["image"]),
                                                    onPressed: ()  {
                                                      setState(() {
                                                        image = imageSelector(
                                                            phone.text,
                                                            contact.text);
                                                      });

                                                    },
                                                    style: TextButton.styleFrom(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,),
                                                      backgroundColor: Colors
                                                          .black,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(24.0),
                                                      ),

                                                    ),
                                                  )),

                                              FittedBox(
                                                  child: ElevatedButton(
                                                    child: Text(
                                                        language[current_language]["EditContact"]["refresh_image"]),
                                                    onPressed: ()  {
                                                      setState(() async {
                                                        imageCache.clear();
                                                        imageCache.clearLiveImages();
                                                        UniqueKey();
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,),
                                                      backgroundColor: Colors
                                                          .lightBlue,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(24.0),
                                                      ),

                                                    ),
                                                  )),

                                              Text("\n"),

                                              TextFormField(
                                                controller: phone,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                keyboardType: TextInputType
                                                    .phone,
                                                decoration: InputDecoration(
                                                    disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                    ),

                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                    ),
                                                    labelText: language[current_language]["CreateContact"]["box1"],
                                                    labelStyle: TextStyle(
                                                        color: Colors.white)
                                                ),
                                              ),
                                              Text("\n"),

                                              TextFormField(
                                                controller: contact,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                    disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                    ),

                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                    ),
                                                    labelText: language[current_language]["CreateContact"]["box2"],
                                                    labelStyle: TextStyle(
                                                        color: Colors.white)
                                                ),
                                              ),

                                              Text("\n"),

                                              ElevatedButton(
                                                child: Text(
                                                  language[current_language]["CreateContact"]["button"],
                                                ),
                                                style: TextButton.styleFrom(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,),
                                                  backgroundColor: colores[mode_counter],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(24.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() async {
                                                    if (phone.text.length > 0) {
                                                      setState(() {
                                                        contactos = [];
                                                        telefonos = [];
                                                        photos = [];
                                                      });

                                                      jsonFile =
                                                      "contacts.json";
                                                      if (image.length > 0) {
                                                        if (image.contains("/data/user/0/com.daviiid99.material_dialer/app_flutter/.jpg") || image.contains(" /data/user/0/com.daviiid99.material_dialer/app_flutter/.png")|| image.contains("/data/user/0/com.daviiid99.material_dialer/app_flutter/.gif")){
                                                          if (image.contains(".jpg")){
                                                             File(image).rename("/data/user/0/com.daviiid99.material_dialer/app_flutter/" + phone.text + ".jpg");
                                                             image = "/data/user/0/com.daviiid99.material_dialer/app_flutter/" + phone.text + ".jpg";
                                                          } else if (image.contains(".png")){
                                                             File(image).rename("/data/user/0/com.daviiid99.material_dialer/app_flutter/" + phone.text + ".png") ;
                                                            image = "/data/user/0/com.daviiid99.material_dialer/app_flutter/" + phone.text + ".png";
                                                          } else if (image.contains(".gif")){
                                                             File(image).rename("/data/user/0/com.daviiid99.material_dialer/app_flutter/" + phone.text + ".gif");
                                                            image = "/data/user/0/com.daviiid99.material_dialer/app_flutter/" + phone.text + ".gif";
                                                            }
                                                            _writeJson(
                                                            phone.text, [contact
                                                                .text, image],
                                                            "contact");

                                                          image = "sdcard/download/profile.png";

                                                          } else {
                                                        _writeJson(
                                                            phone.text, [
                                                          contact.text,
                                                          "$imagePath"
                                                        ], "contact");
                                                      }
                                                      _readJson();
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                language[current_language]["CreateContact"]["toaster"] +
                                                                    "\n" +
                                                                    contact
                                                                        .text +
                                                                    "(" +
                                                                    phone.text +
                                                                    ")"),
                                                          ));
                                                      contact.text = "";
                                                      phone.text = "";
                                                    }}});
                                                },
                                              )
                                            ]
                                        ),
                                      )
                                  );
                                }
                              );
                           }

                         );
                        },
                        icon: Icon(Icons.create_rounded, color: Colors.white
                          ,),
                      ), SizedBox(width: 10,),
                      TextButton.icon(
                        label: Text(
                          language[current_language]["Contacts"]["button2"],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                             fontWeight: FontWeight.bold ),
                        ),
                        style: TextButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ),
                          textStyle: TextStyle(color: Colors.white),
                          backgroundColor: Colors.transparent,
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
                                contactos = [];
                                telefonos = [];
                                photos = [];
                              });

                              jsonFile = "contacts.json";
                              _writeJson(number, [name, imagePath], "contact");
                              _readJson();
                          };
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(language[current_language]["Contacts"]["toaster"] + "\n" + name + "(" + number+ ")"),
                          ));
                        },
                        icon: Icon(Icons.add_rounded, color: Colors.white,),
                      ),
                    ]))
        ),

        ),if(contactos.length == 0) Image.asset("assets/images/empty.png") ,

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
            title: Text(contactos[index], style: TextStyle( fontWeight: FontWeight.bold),),
            subtitle: Text(telefonos[index]),
            ));
        },
      ),

    )]
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
              label: language[current_language]["Contacts"]["navbutton1"],
              icon: IconButton(
                alignment: Alignment.bottomLeft,
                icon: Icon(Icons.import_contacts_rounded),
                onPressed: (){
                  setState(() async {
                     await pickFile();
                  });
                },
              )
            ),
            BottomNavigationBarItem(
              label: language[current_language]["Contacts"]["navbutton2"],
              icon: IconButton(
                alignment: Alignment.bottomRight,
                icon: Icon(Icons.ios_share_rounded),
                onPressed: (){
                  if (myBackupDir == null){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("User cancelled the operation :("),
                    ));
                  } else{
                    exportMultipleContacts();
                    }


                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$myBackupFile"),
                    ));
                  }
              )
            )
          ],
    ),
    );
  }
}