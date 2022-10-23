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

class MaterialDialer extends StatefulWidget{
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  MaterialDialer(this.mode_counter, this.modes, this.colores, this.fonts);
  _MaterialDialerState createState() => _MaterialDialerState(mode_counter, modes, colores, fonts);

}

class _MaterialDialerState extends State<MaterialDialer>{

  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";

  @override
  _MaterialDialerState(this.mode_counter, this.modes, this.colores, this.fonts);


  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colores = [];
  List<Color> fonts  = [];
  List<String> images = ['assets/images/light_banner.png', 'assets/images/black_banner.png'];
  List<String> options = ["Name", "Version", "Build Number", "Package Name"];
  List<String> description = ["", "", "", ""];
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

  @override
    void initState(){
    checkBuild();
    description = [appName, version, buildNumber, packageName];
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: colores[mode_counter],
        appBar: AppBar(
          backgroundColor: colores[mode_counter],
          title: Text("About Material Dialer",
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
                      ));
              }
          ),


    ),
    ]));}

}