import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class MaterialDialer extends StatefulWidget{
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  MaterialDialer(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language);
  _MaterialDialerState createState() => _MaterialDialerState(mode_counter, modes, colores, fonts, current_language, language);

}

class _MaterialDialerState extends State<MaterialDialer>{

  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;


  @override
  _MaterialDialerState(this.mode_counter, this.modes, this.colores, this.fonts, this.current_language, this.language);


  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  List<String> images = ['assets/images/light_banner.png', 'assets/images/black_banner.png'];
  List<String> options = [];
  List<String> description = [];
  List<IconData> icons = [Icons.drive_file_rename_outline_rounded, Icons.format_list_numbered, Icons.build, Icons.gif_box];

  void checkBuild(){
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;

      setState(() {
        description = [appName, version, buildNumber, packageName];
      });
    });}

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }


  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    return "/sdcard/download/";
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

  Future<String> readString(String path) async {
    return await rootBundle.loadString(path);
  }


  @override
  void initState(){
    super.initState();
    checkBuild();
    options = [language[current_language]["About"]["card1"], language[current_language]["About"]["card2"], language[current_language]["About"]["card3"], language[current_language]["About"]["card4"]];
    description = [appName, version, buildNumber, packageName];
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: colores[mode_counter],
        appBar: AppBar(
          backgroundColor: colores[mode_counter],
          title: Text(language[current_language]["About"]["title"],
            style: TextStyle(color: fonts[mode_counter]),

          ),
          iconTheme: IconThemeData(
            color: fonts[mode_counter], //change your color here
          ),
        ),
    body: Column(
    children: <Widget>[
      Text("\n"),
        Image.asset(images[mode_counter]),
      Text("\n"),
    Expanded(
          child : ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(

                      tileColor: colores[mode_counter] ,
                      textColor: fonts[mode_counter],
                      title: Text(options[index]),
                      subtitle: Text(description[index]),
                      leading: Icon(icons[index], color: fonts[mode_counter]),
                      onTap: () {
                        setState(() {
                        });
                        }
                      ),


              );
              }
          ),



    ),

      Column(
        children: <Widget> [
          TextButton.icon(
            label:  Text(
              "Download Latest",
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
            onPressed: () async {
              _permissionReady = await _checkPermission();

              if (_permissionReady) {
                await _prepareSaveDir();
                try {
                  //await Dio().download("https://raw.githubusercontent.com/daviiid99/Material_Dialer/master/version.txt",
                  //    _localPath + "/" + "version.txt");
                  //String ver = readString(_localPath  + "version.txt") as String;
                  //deleteFile(File(_localPath + "/" + "version.txt"));

                  //print(ver);
                 // print(version);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Downloading latest version\nPlease wait...")));
                  await Dio().download("https://github.com/daviiid99/Material_Dialer/releases/download/latest/app-release.apk",
                      _localPath + "/" + "material_dialer.apk");
                  OpenFile.open(_localPath + "/" + "material_dialer.apk");
                  deleteFile(File(_localPath + "/" + "material_dialer.apk"));

                } catch (e) {
                }

              }


            },

            icon: Icon(Icons.download, color: Colors.black,),
          )
        ],
      )
    ],



    ));}

}