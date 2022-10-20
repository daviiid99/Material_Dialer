import 'dart:ffi';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class Contacts extends StatelessWidget{

  var contactos = ["Papa", "Mamá", "Hermana"];
  var telefonos = ["637252015", "663092010", "722347911"];

  void llamar(List<String> telefonos, index) async{
    String number = "tel:+34${telefonos[index]}";
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts"),
    ),
      body : ListView.builder(
        itemCount: contactos.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text(contactos[index]),
            subtitle: Text(telefonos[index]),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              onPressed: (){
                llamar(telefonos, index);
              },
            ),
          );
        },
      ),
      );
  }
}