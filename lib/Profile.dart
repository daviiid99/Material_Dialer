import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:material_calculator/Dialer.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'ManageMap.dart';
import 'History.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'SetLanguage.dart';
import 'package:restart_app/restart_app.dart';
import 'package:file_picker/file_picker.dart';

class Profile extends StatefulWidget{
  @override
  Color color;
  Profile(this.color);

  _ProfileState createState() => _ProfileState(color);
}

class _ProfileState extends State<Profile>{



  final name = TextEditingController();
  late String _jsonString;
  bool _fileExists = false;
  late File _filePath;
  String file = "";
  String currentLanguage = "";
  Color color;

  _ProfileState(this.color);
  Map<dynamic, dynamic> language = {
  };


  Map<dynamic, dynamic> user = {
  };


  // Get app local path for App data
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

// Get file object with full path
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$file');
  }

  // Write latest key and value to json
  void writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    user.addAll(_newJson);
    _jsonString = jsonEncode(user);
    filePath.writeAsString(_jsonString);

  }

  // Read json and update the lists on runtime
  readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        if (file.contains("user.json")) {
          _jsonString = await _filePath.readAsString();
          user = jsonDecode(_jsonString);
        };

        if (file.contains("languages.json")){
          _jsonString = await _filePath.readAsString();
          language = jsonDecode(_jsonString);

        };

        }
        catch (e) {

      }
    }
    setState(() {
      if (file.contains("user.json")) {
        user = jsonDecode(_jsonString);
      };

        if (file.contains("languages.json")){
          this.currentLanguage = language["language"];
        }


      });
  }

  void checkLanguages() async {
    final languagesFile = File(
        "/data/user/0/com.daviiid99.material_dialer/app_flutter/languages.json");
    bool exists = await languagesFile.exists();

    if (exists) {
      setState(() {
        file = "languages.json";
        readJson();
      });
    }
  }

  Future<bool> createEmptyFile() async {
    // This is used for future modifications to detect if it's a clean installation or not

    // Create empty file
    final empty = File("/data/user/0/com.daviiid99.material_dialer/app_flutter/none.json");

    // Check if exists
    bool exists = await empty.exists();

    return exists;

  }

  @override
  void initState(){
    // Set full screen mode for an inmersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    checkLanguages();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        leading: Icon(Icons.face_rounded, color: Colors.blueAccent),
        backgroundColor: Colors.black,
        title: Text(language[currentLanguage]["Profile"]["title"]),
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),
          Text(
            language[currentLanguage]["Profile"]["subtitle"] + "\n",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
          ),
          Text(
            language[currentLanguage]["Profile"]["subtitle2"] + "\n",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Image.asset("assets/images/profile.png"),

          Container(
            child: Container(
              child: Column(
                children: [
                  Text("Enter your name "),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      ),
                    border: OutlineInputBorder(
                    ),
                    labelText: "Name"), cursorColor: Colors.white,
                controller: name,
                keyboardType: TextInputType.name,

              ),

                SizedBox(height: 25,),

                TextButton.icon(
                  label:  Text(
                    language[currentLanguage]["Profile"]["button"],
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.blueAccent,
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  onPressed: ()  {
                    setState(() {
                      file = "user.json";
                      writeJson("name", name.text);

                    });

                    String colorString = color.toString(); // Color(0x12345678)
                    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
                    writeJson("color", valueString);
                    readJson();

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePhoto(language, currentLanguage)),
                      );
                    },
                  icon: Icon(Icons.check, color: Colors.white,),
                ),
                ],
              ),
            ),
          )
          
        ],
      ),

    );
  }
}

class ProfilePhoto extends StatefulWidget{
  @override
  Map <dynamic, dynamic> language = {};
  String currentLanguage = "";
  ProfilePhoto(this.language, this.currentLanguage);
  _ProfilePhotoState createState() => _ProfilePhotoState(language, currentLanguage);
}

class _ProfilePhotoState extends State<ProfilePhoto>{
  @override
  Map <dynamic, dynamic> language = {};
  Map <dynamic, dynamic> user = {};
  String currentLanguage = "";
  _ProfilePhotoState(this.language, this.currentLanguage);
  String path = "";
  String image = "";
  String jsonFile = "user.json";
  String _jsonFile = "";
  String exampleImage = 'assets/images/unnamed.png';

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
    final filePath = await _localFile;

    // Read current map
    _jsonFile = await filePath.readAsString();

    // Assign map string into map object
    user = jsonDecode(_jsonFile);

    //
  }

  void _writeJson(String key, dynamic value) async{
    final filePath = await _localFile;

    // Create temp map
    Map<String, dynamic> myPhoto = {};

    // Save to new map
    myPhoto[key] = value;

    // Overrite old map
    user.addAll(myPhoto);

    // Save old map
    _jsonFile = jsonEncode(user);

    // Overwrite map
    filePath.writeAsString(_jsonFile);
    print(_jsonFile);


    //
  }

  void pickImage() async {
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
                '/data/user/0/com.daviiid99.material_dialer/app_flutter/profile.png');
            image = '/data/user/0/com.daviiid99.material_dialer/app_flutter/profile.png';

          }  else if (path.contains('.jpg')){
            await File(path).rename(
                '/data/user/0/com.daviiid99.material_dialer/app_flutter/profile.jpg');
            image = '/data/user/0/com.daviiid99.material_dialer/app_flutter/profile.jpg';
          } else {
            await File(path).rename(
                '/data/user/0/com.daviiid99.material_dialer/app_flutter/profile.gif');
            image =
            '/data/user/0/com.daviiid99.material_dialer/app_flutter/profile.gif';
          }

          _writeJson("photo", image);
          user["photo"] = image;
          Restart.restartApp();

        });
      }
    }
  }

  void initState(){
    _readJson();
    super.initState();
  }

  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
            language[currentLanguage]["Profile"]["title"],
            style: TextStyle(
                color: Colors.white),
        ),
        
      ),

      body: Column(
        children: [
          SizedBox(height: 5,),
          Text(
            language[currentLanguage]["Profile"]["subtitle_picture"] + "\n",
            style: TextStyle(
              color:  Colors.white,
              fontSize: 25
            ),
          ),

          Text(
            language[currentLanguage]["Profile"]["subtitle_picture2"] + "\n",
            style: TextStyle(
                color:  Colors.white,
                fontSize: 15
            ),
          ),

          Image.asset(
              "assets/images/unnamed.png",

          ),

          SizedBox(height: 25,),


        ElevatedButton(
          child: Text(
            language[currentLanguage]["Profile"]["button2"]
          ),

          onPressed: (){
            pickImage();
          }

        )

        ],
      ),
    );
  }
}
