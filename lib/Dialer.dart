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
import 'DialPadNumbers.dart';
import 'History.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class Dialer extends StatefulWidget{
  @override
  static int mode_counter = 0;
  static List<IconData> modes = [Icons.palette_rounded, Icons.dark_mode];
  static List<Color> colors = [Colors.black];
  static List<Color> fonts = [Colors.white];
  String number = "";
  Dialer(this.number);
  _DialerState createState() => _DialerState(mode_counter, modes, colors, fonts, number);

}

class _DialerState extends State<Dialer>{
  int mode_counter = 0;
  List<IconData> modes = [];
  List<Color> colors = [];
  List<Color> fonts  = [];
  var idioma = ManageMap(jsonFile: "languages.json");
  String number = "";

  _DialerState(this.mode_counter, this.modes, this.colors, this.fonts, this.number);

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

  Map<dynamic, dynamic> user = {
    "color" : Colors.black
  };

  Map<dynamic, dynamic> history = {};

  Map<dynamic, dynamic> language = {
    "language" : "English",

    "English" : {
      "Settings" : {
        "title" : "My Settings",
        "card1_title" : "View Project Source Code",
        "card1_subtitle" : "Open the official GitHub page",
        "card2_title" : "Set UI Language",
        "card2_subtitle" : "Choose your default language",
        "card3_title" : "Donate Us",
        "card3_subtitle" : "Buy me a coffee",
        "card4_title" : "Rate Us",
        "card4_subtitle" : "Rate this App on Google Play Store",
        "card5_title" : "About Material Dialer",
        "card5_subtitle" : "Check App details",
        "image" : 0
      },

      "About" : {
        "title" : "About Material Dialer",
        "card1" : "Name",
        "card2" : "Version",
        "card3" : "Package Name",
        "card4" : "Build Signature",
        "button" : "Check for Updates",
        "toaster" : "Checking for updates\nPlease wait...",
        "toaster2" : "You're on latest release",
        "toaster3" : "Downloading a new update!\nPlease, don't close the app"
      },

      "Contacts" : {
        "title" : "My Contacts",
        "button1" : "Create Contact",
        "button2" : "Pick a Contact",
        "toaster" : "Saved your contact",
        "menu_button" : "Import Contacts",
        "menu_button_2" : "Export Contacts",
        "empty" : "\nNothing here, just leafs"
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

      "Calls" : "Call",

      "History" : {
        "title" : "Calls History",
        "subtitle" : "Last Calls"
      }

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
        "card5_subtitle": "Ver detalles de la aplicación",
        "image" : 1
      },

      "About": {
        "title" : "Sobre Material Dialer",
        "card1": "Nombre",
        "card2": "Versión",
        "card3": "Nombre de paquete",
        "card4": "Firma de compilación",
        "button" : "Buscar Actualizaciones",
        "toaster" : "Buscando actualizaciones\nPor favor, espera...",
        "toaster2" : "You're on latest release",
        "toaster3" : "Descargando una nueva actualización!\nPor favor, no cierre la app"
      },

      "Contacts": {
        "title": "Mis Contactos",
        "button1": "Crear Contacto",
        "button2": "Añadir Contacto",
        "toaster" : "Se ha guardado tu contacto",
        "menu_button" : "Importar Contactos",
        "menu_button_2" : "Exportar Contactos",
        "empty" : "\nNo hay nada, solo hojas"

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

      "Calls": "Llamar",

      "History" : {
        "title" : "Registro de  Llamadas",
        "subtitle" : "Últimas Llamadas"
      }

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
        "title" : "À propos de Material Dialer",
        "card1" : "Nom",
        "card2" : "Version",
        "card3" : "Nom du paquet",
        "card4" : "Signature de construction",
        "button" : "Vérifier les mises à jour",
        "toaster" : "Vérification des mises à jour\nS'il vous plaît, attendez...",
        "toaster2" : "Vous êtes sur la dernière version",
        "toaster3" : "Téléchargement d'une nouvelle mise à jour!\nS'il vous plaît, ne fermez pas l'application"
      },

      "Contacts" : {
        "title" : "Mes Contacts",
        "button1" : "Créer contact",
        "button2" : "Choisissez contact",
        "toaster" : "Saved your contact",
        "menu_button" : "Contacts d'importation",
        "menu_button_2" : "Exporter des contacts",
        "empty" : "\nRien ici, juste des feuilles"
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

      "Calls" : "Téléphoner",

      "History" : {
        "title" : "Historique des téléphone",
        "subtitle" : "Dernier Appels Téléphoniques"
      }

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
        "title" : "Di Material Dialer",
        "card1" : "Nome",
        "card2" : "Versione",
        "card3" : "Nome del pacchetto",
        "card4" : "Firma di build",
        "button" : "Controlla gli aggiornamenti",
        "toaster" : "Verifica aggiornamenti\nattendere prego...",
        "toaster2" : "Sei all'ultima versione",
        "toaster3" : "Download di un nuovo aggiornamento!\nPer favore, non chiudere l'app"
      },

      "Contacts" : {
        "title" : "I miei Contatti",
        "button1" : "Crea Contatto",
        "button2" : "Scegli Contatto",
        "toaster" : "Saved your contact",
        "menu_button" : "Importa contatti",
        "menu_button_2" : "Esporta contatti",
        "empty" : "\nNiente qui, se ne va"
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

      "Calls" : "Chiamata",

      "History" : {
        "title" : "Cronologia chiamate",
        "subtitle" : "Ultime Chiamate"
      }

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
        "title" : "Um Material Dialer",
        "card1" : "Name",
        "card2" : "Ausführung",
        "card3" : "Paketnamen",
        "card4" : "Build-Unterschrift",
        "button" : "Auf Updates prüfen",
        "toaster" : "Suche nach Updates\nWarten Sie mal...",
        "toaster2" : "Sie sind auf der neuesten Version",
        "toaster3" : "Laden Sie ein neues Update herunter!\nBitte schließen Sie die App nicht"
      },

      "Contacts" : {
        "title" : "Meine Kontakte",
        "button1" : "Kontakt Erstellen",
        "button2" : "Wählen Sie einen Kontakt aus",
        "toaster" : "Saved your contact",
        "menu_button" : "Kontakte importieren",
        "menu_button_2" : "Kontakte exportieren",
        "empty" : "\nNichts hier, nur Blätter"
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

      "Calls" : "Anruf",

      "History" : {
        "title" : "Anrufverlauf",
        "subtitle" : "Letzte Anrufe"
      }

    }
  };

  bool _fileExists = false;
  late File _filePath;
  String jsonFile = "languages.json";
  late String _jsonString;
  String currentLanguage = "English";
  int index = 0;

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
  restoreValues() async {
    jsonFile = "user.json";
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
          _jsonString = await _filePath.readAsString();
          user = jsonDecode(_jsonString);
      } catch (e) {

      }
    }
    setState(() {
      String str = user["color"];
      int value = int.parse(str, radix: 16);
      Color otherColor = new Color(value);
      colors[0] = otherColor;

      });

  }

  // Read json and update the lists on runtime
  readJson() async {
    _filePath = await _localFile;
    _fileExists = await _filePath.exists();

    if (_fileExists) {
      try {
        if(jsonFile.contains("languages.json")) {
          _jsonString = await _filePath.readAsString();
          language = jsonDecode(_jsonString);
        }

        if (jsonFile.contains("user.json")){
          _jsonString = await _filePath.readAsString();
          user = jsonDecode(_jsonString);
        }
      } catch (e) {

      }
    }
    setState(() {
      if (jsonFile.contains("languages.json")) {
        this.currentLanguage = language["language"];
        language = jsonDecode(_jsonString);
        setLanguage();

      }

      else if(jsonFile.contains("user.json")){
        user = jsonDecode(_jsonString);
        String str = user["color"];
        int value = int.parse(str, radix: 16);
        Color otherColor = new Color(value);

        setState(() {
          colors[0] = otherColor;
          print(colors);
        });

      }
    });

  }

  // Write latest key and value to json
  void writeJson(String key, dynamic value) async {
    final filePath = await _localFile;
    Map<String, dynamic> _newJson = {key: value};

    if (jsonFile == "languages.json") {
      language.addAll(_newJson);
      _jsonString = jsonEncode(language);
      filePath.writeAsString(_jsonString);
    }

    else if (jsonFile == "user.json"){
      user.addAll(_newJson);
      _jsonString = jsonEncode(user);
      filePath.writeAsString(_jsonString);

    }
  }

  void setLanguage() async{

    if (currentLanguage == "English") {
      index = 0;
    }
    else if (currentLanguage == "Español") {
      index = 1;
    }
     else if(currentLanguage == "Français"){
       index = 2;
    }

    else if(currentLanguage == "Italiano"){
      index = 3;
    }

    else if(currentLanguage == "Deutsch"){
      index = 4;
    }

    setState(() {
      restoreValues();
    });

  }


  @override
  void initState(){

    jsonFile = "languages.json";
    readJson();

      setState(() {
        jsonFile = "languages.json";
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
          icon: Icon(Icons.palette_rounded, color: fonts[mode_counter]),
          tooltip: 'Navigation menu',
            onPressed: () => {
            showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Colors.transparent,
              content: SingleChildScrollView(

              child: BlockPicker(
                pickerColor: colors[0], //default color
                onColorChanged: (Color color) { //on color picked
                  jsonFile = "user.json";
                  String colorString = color.toString(); // Color(0x12345678)
                  String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
                  writeJson("color", valueString);
                  readJson();
                  Navigator.pop(context);

                })
              ),
              );
            }
            )
          }
        ),
        backgroundColor: colors[mode_counter],
        actions:  [
          IconButton(
              icon: Icon(Icons.settings,color: fonts[mode_counter]),
            onPressed: () {
                setState(() {
                });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(mode_counter, modes, colors, fonts, currentLanguage, language, index),
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
                    MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colors, fonts, currentLanguage, language, number, history)),
                  );
                },
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon : IconButton(
                icon: Icon(Icons.history_rounded), color: fonts[mode_counter],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => History(mode_counter, modes, colors, fonts, currentLanguage, language)),
                  );
                }
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon : IconButton(
                icon: Icon(Icons.face_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language, history)),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}


