import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class ManageMap {
bool _fileExists = false;
late File _filePath;
String jsonFile = "contacts.json";
ManageMap({this.jsonFile = "contacts.json"});

// First initialization of _json (if there is no json in the file)
Map<dynamic, dynamic> mapa = {};
late String _jsonString;
String data = "";

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

// Write latest key and value to json
void writeJson(String key, dynamic value) async {
final filePath = await _localFile;
Map<String, dynamic> _newJson = {key: value};
mapa.addAll(_newJson);
_jsonString = jsonEncode(mapa);
filePath.writeAsString(_jsonString);
}

// Read json and update the lists on runtime
void readJson() async {
_filePath = await _localFile;
_fileExists = await _filePath.exists();

if (_fileExists) {
try {
_jsonString = await _filePath.readAsString();
mapa = jsonDecode(_jsonString);
} catch (e) {

}
}
}
}