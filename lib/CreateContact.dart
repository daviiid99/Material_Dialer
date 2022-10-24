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

class CreateContact extends StatefulWidget {
  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact>{

  final phone = TextEditingController();
  final contact = TextEditingController();
  var mapa = ManageMap();

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
          title: const Text("Create Contact"),
        ),
        body: Container(
            child: Column(
                children: <Widget>[
                  Text("\n"),
                  TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                    ),
                  ),
                  Text("\n"),

                  TextFormField(
                    controller: contact,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),

                  Text("\n\n\n"),

                  TextButton.icon(
                    label: const Text(
                      "Save Contact",
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
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context)=> Dialer()));
                      setState(() {
                        mapa.writeJson(phone.text, contact.text );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Saved your contact\n" + contact.text + "(" + phone.text+ ")"),
                      ));
                    },
                    icon: Icon(Icons.face_rounded, color: Colors.black,),
                  )
                ]
            )));
  }
}