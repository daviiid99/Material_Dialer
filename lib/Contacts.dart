import 'dart:ffi';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';


class Contacts extends StatefulWidget{
   @override
   _ContactState createState() => _ContactState();
}


class _ContactState extends State<Contacts>{

  var contactos = ["Emergencies"];
  var telefonos = ["112"];

  void llamar(List<String> telefonos, index) async{
    String number = "tel:${telefonos[index]}";
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  List colors = [Colors.blue, Colors.red,Colors.yellow, Colors.green];

  late String name, number;
  final FlutterContactPicker contactPicker = new FlutterContactPicker();

  @override
  void initState(){
    number = "";
    name = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
          onPressed: () async {
            Contact? contact = await contactPicker.selectContact();
            if (contact !=null){
              number = contact.phoneNumbers![0];
              name = contact.fullName.toString();
              setState(() {
                contactos.add(name);
                telefonos.add((number.toString()));
                Contacts();
              });
            }
          },
          child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("My Contacts"),
    ),
      body : ListView.builder(
        itemCount: contactos.length,
        itemBuilder: (context, index){
          return ListTile(
            tileColor: Colors.black ,
            textColor: Colors.white,
            leading: Icon(Icons.supervised_user_circle, color: Colors.blueGrey,),
            title: Text(contactos[index]),
            subtitle: Text(telefonos[index]),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.blueAccent,),
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