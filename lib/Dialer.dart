import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'custom_button.dart';
import 'Contacts.dart';


class Dialer extends StatelessWidget{

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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.person_rounded, color: Colors.white),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        backgroundColor: Colors.black,
        actions: const [
          IconButton(
              icon: Icon(Icons.menu,color: Colors.white),
              onPressed: null,

          ),
        ],
      ),
      body : Center(
        child:
          DialPad(),

      ),

        bottomNavigationBar: BottomNavigationBar(
          iconSize: 35,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white70,
          selectedItemColor: Colors.white70,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.call_rounded),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_page),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Messages',
            ),
          ],
        ),
      );
  }
}

class DialPad extends StatelessWidget{
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
              .height / 14.9,
          color: Colors.black,
          child: const Center(child: Text("Dialer", style: TextStyle(fontSize: 41,
              color: Colors.white,
              backgroundColor: Colors.black),),),

        ),
        DialPadNumbers()],

    );
  }
}

class DialPadNumbers extends StatefulWidget {
  @override
  _DialPadNumberState createState() => _DialPadNumberState();
}

class _DialPadNumberState extends State<DialPadNumbers>{

  void llamar(String telefono) async{
    await FlutterPhoneDirectCaller.callNumber("+34$telefono");
  }

  // TO-DO
  //void _navigateToNextScreen(BuildContext context) {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => llamar()));
 // }

  String addNumber(String numero, String full){
    if (full == "Enter your number"){
      full = "";
    }
    return full += numero;
  }
  @override
  String number = "Enter your number";

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
              .height / 5.62,
          color: Colors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 45,),
              Text(number, style: TextStyle(fontSize: 38,
              color: Colors.white,
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
              .height / 8.6,
          color: Colors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 45,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("1"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("1", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("2"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("2", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("3"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("3", number);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 30,),
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
              .height / 8.6,
          color: Colors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 45,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("4"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("4", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("5"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("5", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("6"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("6", number);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 30,),
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
              .height / 8.6,
          color: Colors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 45,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("7"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("7", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("8"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("8", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("9"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("9", number);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 30,),
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
              .height / 8.6,
          color: Colors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 45,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("*"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("*", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("0"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("0", number);
                      });
                    },
                  ),
                ),
              ), const SizedBox(width: 30,),
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Text("#"),
                    onPressed: () {
                      setState(() {
                        number = addNumber("#", number);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 30,),
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
          .height / 10.3,
      color: Colors.black,
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    const SizedBox(width: 45,),
          TextButton.icon(
            label: const Text(
              "Call",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: Colors.green,fixedSize: const Size(300, 53),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
            ),
            onPressed: () => {llamar(number) ,
            setState(() {
            number = "Enter your number";
            })},
            icon: Icon(Icons.call, color: Colors.black,),
          ),
    ]))]);
  }
}
