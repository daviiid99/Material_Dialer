import 'dart:ffi';
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


class CreateContact extends StatefulWidget {
  @override
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  CreateContact(this.current_language, this.language);
  _CreateContactState createState() => _CreateContactState(current_language, language);
}

class _CreateContactState extends State<CreateContact>{

  final phone = TextEditingController();
  final contact = TextEditingController();
  var mapa = ManageMap();
  String current_language = "";
  Map<dynamic, dynamic> language = {};

  _CreateContactState(this.current_language, this.language);

  @override
  void initState(){
    mapa.readJson();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phone.dispose();
    contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title:  Text(language[current_language]["CreateContact"]["title"]),
        ),
        body: Container(
            child: Column(
                children: <Widget>[
                  Text("\n"),
                  TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.number,
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
                        mapa.writeJson(phone.text, contact.text );
                        Restart.restartApp();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(language[current_language]["CreateContact"]["toaster"]+"\n" + contact.text + "(" + phone.text+ ")"),
                      ));
                    },

                    icon: Icon(Icons.face_rounded, color: Colors.black,),
                  )
                ]
            )));
  }
}