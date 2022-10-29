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
import 'DialPadNumbers.dart';
import 'History.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'SetLanguage.dart';
import 'package:restart_app/restart_app.dart';

class Profile extends StatefulWidget{
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{

  final name = TextEditingController();
  late String _jsonString;
  bool _fileExists = false;
  late File _filePath;


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
    return File('/data/user/0/com.daviiid99.material_dialer/app_flutter/user.json');
  }

  // Write latest key and value to json
  void writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    user.addAll(_newJson);
    _jsonString = jsonEncode(user);
    filePath.writeAsString(_jsonString);
    print(_jsonString);
    print(user);

  }

  // Read json and update the lists on runtime
  readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
          _jsonString = await _filePath.readAsString();
          user = jsonDecode(_jsonString);
      } catch (e) {

      }
    }
    setState(() {
        user = jsonDecode(_jsonString);


      });
  }

  @override
  void initState(){
    readJson();

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Icon(Icons.face_rounded, color: Colors.blueAccent),
        backgroundColor: Colors.black,
        title: Text("Creating Your Profile"),
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),
          Text(
              "Tell Us About You\n",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
          ),
          Text(
              "We need your name before continue\n",
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
                    "Save your profile",
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
                  onPressed: () {
                    setState(() {
                      writeJson("name", name.text);
                    });

                    Restart.restartApp();
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
