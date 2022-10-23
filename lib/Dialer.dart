import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';

class Dialer extends StatefulWidget{
  @override
  static int mode_counter = 1;
  static List<IconData> modes = [Icons.light_mode, Icons.dark_mode];
  static List<Color> colors = [Colors.white, Colors.black];
  static List<Color> fonts = [Colors.black, Colors.white];
  _DialerState createState() => _DialerState(mode_counter, modes, colors, fonts);
}

class _DialerState extends State<Dialer>{
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];

  _DialerState(this.mode_counter, this.modes, this.colors, this.fonts);

  void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts)));
   }

  static const List<Widget> _pages = <Widget>[
    Icon(
      Icons.call_rounded,
      size: 150,
    ),
    Icon(
      Icons.contact_page,
      size: 150,
    ),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: colors[mode_counter],
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(modes[mode_counter], color: fonts[mode_counter]),
          tooltip: 'Navigation menu',
            onPressed: () => {
            setState((){
            if(mode_counter == 1){
            mode_counter = 0;
            } else {
            mode_counter = 1;
            }
            },
            )}
        ),
        backgroundColor: colors[mode_counter],
        actions:  [
          IconButton(
              icon: Icon(Icons.settings,color: fonts[mode_counter]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(mode_counter, modes, colors, fonts)),
              );
            },

          ),
        ],
      ),
      body : Center(
            child: Text("Material\n  Dialer", style: TextStyle(fontSize: 41,
                color: fonts[mode_counter],
                backgroundColor: colors[mode_counter]),),
    ),

        bottomNavigationBar: BottomNavigationBar(
          iconSize: 35,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          backgroundColor: colors[mode_counter],
          unselectedItemColor: fonts[mode_counter],
          selectedItemColor: fonts[mode_counter],

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: 'Calls',
              icon : IconButton(
                icon: Icon(Icons.call_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colors, fonts)),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon : IconButton(
                icon: Icon(Icons.contact_page), color: colors[mode_counter],
                onPressed: () {null;}
              ),
            ),
            BottomNavigationBarItem(
              label: 'Contacts',
              icon : IconButton(
                icon: Icon(Icons.face_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts)),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}

class DialPadNumbers extends StatefulWidget {
  @override
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];
  DialPadNumbers(this.mode_counter, this.modes, this.colors, this.fonts);
  _DialPadNumberState createState() => _DialPadNumberState(mode_counter, modes, colors, fonts);
}

class _DialPadNumberState extends State<DialPadNumbers>{

  // Recover theme styles
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];
  _DialPadNumberState(this.mode_counter, this.modes, this.colors, this.fonts);
  double fontsize = 55;

  bool _fileExists = false;
  late File _filePath;

  // First initialization of _json (if there is no json in the file)
  Map<dynamic, dynamic> mapa = {};
  late String _jsonString;
  String data = "";

  void llamar(String telefono) async{
    await FlutterPhoneDirectCaller.callNumber("$telefono");
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

  void saveContact(String telefono) async {
    _writeJson(telefono, "myContact");
}

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
  }

  // TO-DO
  //void _navigateToNextScreen(BuildContext context) {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => llamar()));
 // }

  String addNumber(String numero, String full){
    if(full.length == 3) {
      full += " ";
    }
    else if(full.length == 6){
      full += " ";
    } else if (full.length == 9){
      full += " ";
    }
    return full += numero;
  }

  double checkFont(String numero, double font){

    if(numero.length == 5){
      font -= 5;
    } else if (numero.length == 8) {
      font -= 5;
    } else if (numero.length > 8 && font > 45){
      font = 45;
    }  else if (numero.length == 1) {
      font == 55;
    } else if (numero.length > 12){
      font = 25;
    }

    return font;

  }

  String removeCharacter(String numero){
    var str = "";
    str = numero.substring(0, numero.length - 1);
    return str ;
  }
  @override
  String number = "";

  @override
  void initState(){
    _readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height / 6,
          color: colors[mode_counter],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 45, height: 50,),
              Text(number, style: TextStyle(fontSize: fontsize,
              color: fonts[mode_counter], decorationColor: colors[mode_counter]
              ))],
          ),
        ), Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height / 6,
          color: colors[mode_counter],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("1"), focusColor: fonts[mode_counter],
                    onPressed: () {
                      setState(() {
                        number = addNumber("1", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("2"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("2", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("3"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("3", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 23.5,),
            ],
          ),
        ), Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height / 6,
          color: colors[mode_counter],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("4"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("4", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("5"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("5", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("6"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("6", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 23.5,),
            ],
          ),
        ), Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height / 6,
          color: colors[mode_counter],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("7"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("7", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("8"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("8", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("9"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("9", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 23.5,),
            ],
          ),
        ), Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height / 6,
          color: colors[mode_counter],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("+"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("+", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("0"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("0", number);
                        fontsize = checkFont(number, fontsize);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 23.5,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.backspace_outlined, color: Colors.white,),
                    onPressed: () {
                      setState(() {
                        number = removeCharacter(number);
                        if (fontsize < 55){
                          fontsize += 3;
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 23.5,),
            ],
          ),
        ),
        Container(
          width: MediaQuery
              .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height / 6,
      color: colors[mode_counter],
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    const SizedBox(width: 23.5,),
          TextButton.icon(
            label: const Text(
              "Call",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.green,fixedSize: const Size(340, 53),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onPressed: () => {llamar(number) ,
            setState(() {
            number = "";
            })},
            icon: Icon(Icons.call, color: Colors.black,),
          ), const SizedBox(width: 46,),

    ]))]);
  }
}
