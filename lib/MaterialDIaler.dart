import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode, rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<String> images = ['assets/images/black_banner.png'];
  List<String> options = [];
  List<String> description = [];
  List<IconData> icons = [Icons.drive_file_rename_outline_rounded, Icons.format_list_numbered,Icons.add_box, Icons.android_rounded, ];
  late String _release;

  void checkBuild(){
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildSignature;

      setState(() {
        description = [appName, version, packageName, buildNumber];
      });
    });}

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  void _read() async {
    try {
      await Dio().download("https://raw.githubusercontent.com/daviiid99/Material_Dialer/master/version.txt",
          '/sdcard/download/' + "/" + "version.txt");
      File file = File('/sdcard/download/version.txt');
      var res  = await file.readAsString();
      deleteFile(file); // Delete file for avoid issues next time

      setState(() {
        _release = res;

      });

    } catch (e) {
      print("Couldn't read file");
    }


  }

  _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    await launchUrl(_url,mode: LaunchMode.externalApplication);
  }


  @override
  void initState(){
    // Set full screen mode for an inmersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    _read();
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
          elevation: 0.0,
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
                    language[current_language]["About"]["button"],
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Colors.black),
                    backgroundColor: Colors.green, fixedSize: const Size(340, 53),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  onPressed: () async {

                    try {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(language[current_language]["About"]["toaster"]),
                      ));

                      if(_release.contains(version) == false){
                        String latest = _release;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(language[current_language]["About"]["toaster3"]),
                        ));

                        _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.material_dialer");
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(language[current_language]["About"]["toaster2"]),
                        ));

                      }

                    } catch (e) {
                    }
                  },

                  icon: Icon(Icons.download, color: Colors.black,),
                ),
                Text("\n"),
              ],
            )
          ],



        ));}

}