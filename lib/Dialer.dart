import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';

class Dialer extends StatefulWidget{
  @override
  _DialerState createState() => _DialerState();
}

class _DialerState extends State<Dialer>{
  static int mode_counter = 1;
 static List<IconData> modes = [Icons.light_mode, Icons.dark_mode];
 static List<Color> colors = [Colors.white, Colors.black];
 static List<Color> fonts = [Colors.black, Colors.white];

  void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Contacts()));
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
                MaterialPageRoute(builder: (context) => Settings()),
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
                    MaterialPageRoute(builder: (context) => DialPadNumbers()),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              label: 'Contacts',
              icon : IconButton(
                icon: Icon(Icons.contact_page),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contacts()),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              label: 'Messages',
              icon : IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
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
  _DialPadNumberState createState() => _DialPadNumberState();
}

class _DialPadNumberState extends State<DialPadNumbers>{

  // Recover theme styles
  int mode = _DialerState.mode_counter;
  List<IconData> modes = _DialerState.modes;
  List<Color> colors = _DialerState.colors;
  List<Color> fonts  = _DialerState.fonts;

  void llamar(String telefono) async{
    await FlutterPhoneDirectCaller.callNumber("+34$telefono");
  }

  // TO-DO
  //void _navigateToNextScreen(BuildContext context) {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => llamar()));
 // }

  String addNumber(String numero, String full){
    return full += numero;
  }

  String removeCharacter(String numero){
    var str = "";
    str = numero.substring(0, numero.length - 1);
    return str ;
  }
  @override
  String number = "";

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
          color: colors[mode],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 45, height: 50,),
              Text(number, style: TextStyle(fontSize: 55,
              color: fonts[mode],
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
          color: colors[mode],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 20,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("1"), focusColor: fonts[mode],
                    onPressed: () {
                      setState(() {
                        number = addNumber("1", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20,),
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
          color: colors[mode],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20,),
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
          color: colors[mode],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20,),
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
          color: colors[mode],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 20,),
              SizedBox(
                height: 95.0,
                width: 95.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: Colors.purple,
                    child: Text("#"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("#", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 20,),
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
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20,),
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
      color: colors[mode],
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    const SizedBox(width: 20,),
          TextButton.icon(
            label: const Text(
              "Call",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.green,fixedSize: const Size(160, 53),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onPressed: () => {llamar(number) ,
            setState(() {
            number = "";
            })},
            icon: Icon(Icons.call, color: Colors.black,),
          ), const SizedBox(width: 20,),
          TextButton.icon(
            label: const Text(
              "New Contact",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.orange,fixedSize: const Size(160, 53),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onPressed: () => {null},
            icon: Icon(Icons.face_rounded, color: Colors.black,),
          ),
    ]))]);
  }
}
