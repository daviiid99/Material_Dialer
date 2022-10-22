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

class Contacts extends StatefulWidget{
   @override
   _ContactState createState() => _ContactState();
}


class _ContactState extends State<Contacts>{

  var filePath = 'assets/contacts.json';
  var contactos = ["Example"];
  var telefonos = ["123"];
  bool _fileExists = false;
  late File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<dynamic, dynamic> mapa = {};
  late String _jsonString;
  String data = "";

  loadJson() async {
    data = await rootBundle.loadString('assets/contacts.json');
    mapa = json.decode(data);
    setState(() {
      contactos = addContactsToList(mapa, contactos, telefonos);
      telefonos = addPhonesToList(mapa, contactos, telefonos);

    });
  }

  updateJson(Map<dynamic, dynamic> mapa) async {
    json.encode(mapa);

  }

  // Get app local path for App data
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get file object with full path
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contacts.json');
  }

  // Write latest key and value to json
  void _writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    mapa.addAll(_newJson);
    _jsonString = jsonEncode(mapa);
    filePath.writeAsString(_jsonString);
  }

  // Read json and update the lists on runtime
  void _readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        _jsonString = await _filePath.readAsString();
        mapa = jsonDecode(_jsonString);
      } catch (e) {

      }
    }
    setState(() {
      contactos = addContactsToList(mapa, contactos, telefonos);
      telefonos = addPhonesToList(mapa, contactos, telefonos);

    });
  }

  void llamar(List<String> telefonos, index) async{
    String number = "tel:${telefonos[index]}";
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  // Add contacts entries to lists
  List<String> addContactsToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos){

    for(String key in dic.keys){
        if(telefonos.contains(key) == false){
          contactos.add(dic[key]);
        }
      }

    return contactos;
  }


  // Add phones entries to lists
  List<String> addPhonesToList (Map<dynamic, dynamic> dic ,List<String> contactos, List<String> telefonos){

    for(String key in dic.keys){
        if(telefonos.contains(key) == false){
          telefonos.add(key);
      }
    }

    return telefonos;
  }



  List colors = [Colors.blue, Colors.red,Colors.yellow, Colors.green];

  late String name, number;
  final FlutterContactPicker contactPicker = new FlutterContactPicker();

  @override
  void initState(){
    if(contactos.contains("Example") && telefonos.contains("123")) {
      contactos.remove("Example") && telefonos.remove("123");

    }
    _readJson();
    number = "";
    name = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context){


    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Contact? contact = await contactPicker.selectContact();
            if (contact !=null){
              number = contact.phoneNumbers![0];
              name = contact.fullName.toString();
              setState(() {
                mapa[number] = name;
                contactos = addContactsToList(mapa, contactos, telefonos);
                telefonos = addPhonesToList(mapa, contactos, telefonos);
                _writeJson(number, name);
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