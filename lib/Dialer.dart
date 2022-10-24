import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'ManageMap.dart';

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
  var idioma = ManageMap(jsonFile: "languages.json");

  _DialerState(this.mode_counter, this.modes, this.colors, this.fonts);

  void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language)));
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

  Map<dynamic, dynamic> language = {
    "language" : "English",

    "English" : {
      "Settings" : {
        "title" : "My Settings",
        "card1_title" : "View Project Source Code",
        "card1_subtitle" : "Open the official GitHUb page",
        "card2_title" : "Set UI Language",
        "card2_subtitle" : "Choose your default language",
        "card3_title" : "Donate Us",
        "card3_subtitle" : "Buy me a coffee",
        "card4_title" : "Rate Us",
        "card4_subtitle" : "Rate this App on Google Play Store",
        "card5_title" : "About Material Dialer",
        "card5_subtitle" : "Check App details"
      },

      "About" : {
        "card1" : "Name",
        "card2" : "Version",
        "card3" : "Build Number",
        "card4" : "Package Name"
      },

      "Contacts" : {
        "title" : "My Contacts",
        "button1" : "Create Contact",
        "button2" : "Pick a Contact"
      },

      "CreateContact" : {
        "title" : "Create Contact",
        "box1" : "Phone",
        "box2" : "Name",
        "button" : "Save Contact"
      },

      "Country" : {
        "title" : "Choose Your Language",
        "toaster" : "Default language set to :"
      },

      "Calls" : "Call"

    },

    "Español" : {
      "Settings": {
        "title": "Mis Ajustes",
        "card1_title": "Ver código fuente del programa",
        "card1_subtitle": "Abrir la página oficial de GitHub",
        "card2_title": "Asignar idioma a interfaz",
        "card2_subtitle": "Selecciona tu idioma por defecto",
        "card3_title": "Haz una donación",
        "card3_subtitle": "Págame un café",
        "card4_title": "Danos una puntuación",
        "card4_subtitle": "Puntua esta aplicación en Google Play Store",
        "card5_title": "Sobre Material Dialer",
        "card5_subtitle": "Ver detalles de la aplicación"
      },

      "About": {
        "card1": "Nombre",
        "card2": "Versión",
        "card3": "Número de compilación",
        "card4": "Nombre de paquete"
      },

      "Contacts": {
        "title": "Mis Contactos",
        "button1": "Crear Contacto",
        "button2": "Añadir Contacto"
      },

      "CreateContact": {
        "title": "Crear Contacto",
        "box1": "Teléfono",
        "box2": "Nombre",
        "button": "Guardar Contacto",
        "toaster" : "Guardado el contacto"
      },

      "Country" : {
        "title" : "Elige Tu Idioma",
        "toaster" : "Idioma por defecto cambiado a :"
      },

      "Calls": "Llamar"

    },

    "Français" : {
      "Settings" : {
        "title" : "Mes Paramètres",
        "card1_title" : "Afficher le code source du projet",
        "card1_subtitle" : "Ouvrez la page officielle GitHUb",
        "card2_title" : "Définir la langue de l'interface utilisateur",
        "card2_subtitle" : "Choisissez votre langue par défaut",
        "card3_title" : "Faites-nous un don",
        "card3_subtitle" : "Achetez-moi un café",
        "card4_title" : "Évaluez nous",
        "card4_subtitle" : "Évaluez cette application sur Google Play Store",
        "card5_title" : "À propos du Material Dialer",
        "card5_subtitle" : "Vérifier les détails de l'application"
      },

      "About" : {
        "card1" : "Nom",
        "card2" : "Version",
        "card3" : "Numéro de construction",
        "card4" : "Nom du paquet"
      },

      "Contacts" : {
        "title" : "Mes Contacts",
        "button1" : "Créer un contact",
        "button2" : "Choisissez un contact"
      },

      "CreateContact" : {
        "title" : "Créer un Contact",
        "box1" : "Téléphone",
        "box2" : "Nom",
        "button" : "Enregistrer le Contact"
      },

      "Country" : {
        "title" : "Choisissez votre Langue",
        "toaster" : "Langue par défaut définie sur :"
      },

      "Calls" : "Téléphoner"

    },

    "Italiano" : {
      "Settings" : {
        "title" : "Le mie Impostazioni",
        "card1_title" : "Visualizza il codice sorgente del progetto",
        "card1_subtitle" : "Apri la pagina ufficiale di GitHub",
        "card2_title" : "Imposta la lingua dell'interfaccia utente",
        "card2_subtitle" : "Scegli la tua lingua predefinita",
        "card3_title" : "Donaci",
        "card3_subtitle" : "Offrimi un caffè",
        "card4_title" : "Valutaci",
        "card4_subtitle" : "Valuta questa app su Google Play Store",
        "card5_title" : "Informazioni su Material Dialer",
        "card5_subtitle" : "Controlla i dettagli dell'app"
      },

      "About" : {
        "card1" : "Nome",
        "card2" : "Versione",
        "card3" : "Numero di build",
        "card4" : "Nome del pacchetto"
      },

      "Contacts" : {
        "title" : "I miei Contatti",
        "button1" : "Crea Contatto",
        "button2" : "Scegli Contatto"
      },

      "CreateContact" : {
        "title" : "Crea Contatto",
        "box1" : "Telefono",
        "box2" : "Nome",
        "button" : "Salva Contatto"
      },

      "Country" : {
        "title" : "Scegli la tua Lingua",
        "toaster" : "Lingua predefinita impostata su :"
      },

      "Calls" : "Chiamata"

    },

    "Deutsch" : {
      "Settings" : {
        "title" : "Meine Einstellungen",
        "card1_title" : "Projektquellcode anzeigen",
        "card1_subtitle" : "Öffnen Sie die offizielle GitHub-Seite",
        "card2_title" : "Legen sie UI",
        "card2_subtitle" : "Wählen Sie Ihre Standardsprache",
        "card3_title" : "Spenden Sie uns",
        "card3_subtitle" : "Kaufen Sie mir einen Kaffee",
        "card4_title" : "Bewerten Sie uns",
        "card4_subtitle" : "Bewerten Sie diese App im Google Play Store",
        "card5_title" : "Über Material Dialer",
        "card5_subtitle" : "Überprüfen Sie die App-Details"
      },

      "About" : {
        "card1" : "Name",
        "card2" : "Ausführung",
        "card3" : "Build-Nummer",
        "card4" : "Paketnamen"
      },

      "Contacts" : {
        "title" : "Meine Kontakte",
        "button1" : "Kontakt Erstellen",
        "button2" : "Wählen Sie einen Kontakt aus"
      },

      "CreateContact" : {
        "title" : "Kontakt Erstellen",
        "box1" : "Telefon",
        "box2" : "Name",
        "button" : "Kontakt speichern"
      },

      "Country" : {
        "title" : "Wähle deine Sprache",
        "toaster" : "Standardsprache eingestellt auf :"
      },

      "Calls" : "Anruf"

    },

    "中国人" : {

    },

    "日本" : {

    }
  };

  bool _fileExists = false;
  late File _filePath;
  String jsonFile = "languages.json";
  late String _jsonString;
  late String currentLanguage;

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

  // Read json and update the lists on runtime
  readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        _jsonString = await _filePath.readAsString();
        language = jsonDecode(_jsonString);
      } catch (e) {

      }
    }
    setState(() {
      this.currentLanguage = language["language"];
      language = jsonDecode(_jsonString);
    });

  }

  // Write latest key and value to json
  void writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};
    language.addAll(_newJson);
    _jsonString = jsonEncode(language);
    filePath.writeAsString(_jsonString);
  }

  @override
  void initState(){
    readJson();
    setState(() {
      readJson();
      currentLanguage = language["language"];
    });
    super.initState();
  }

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
                MaterialPageRoute(builder: (context) => Settings(mode_counter, modes, colors, fonts, currentLanguage, language),
              ));
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
                label: '',
              icon : IconButton(
                icon: Icon(Icons.call_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colors, fonts, currentLanguage, language)),
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
              label: "",
              icon : IconButton(
                icon: Icon(Icons.face_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language)),
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
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  DialPadNumbers(this.mode_counter, this.modes, this.colors, this.fonts, this.current_language, this.language);
  _DialPadNumberState createState() => _DialPadNumberState(mode_counter, modes, colors, fonts, current_language, language);
}

class _DialPadNumberState extends State<DialPadNumbers>{

  // Recover theme styles
  int mode_counter = 1;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];
  String current_language = "";
  Map<dynamic, dynamic> language = {};
  _DialPadNumberState(this.mode_counter, this.modes, this.colors, this.fonts, this.current_language, this.language);
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
            label: Text(
              language[current_language]["Calls"],
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
