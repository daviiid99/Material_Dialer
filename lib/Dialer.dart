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
import 'SetLanguage.dart';
import 'Profile.dart';
import 'package:intl/intl.dart';
import 'package:quick_actions/quick_actions.dart';
import 'MaterialDIaler.dart';

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
  String name = "";
  DateTime now = DateTime.now();
  String setTime = "";
  QuickActions quickActions = const QuickActions();

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
  };

  Map<dynamic, dynamic> history = {};

  Map<dynamic, dynamic> language = {
    "language" : "English",

    "English" : {

      "Home" : {
        "title_morning" : "Good morning",
        "title_afternoon" : "Good afternoon",
        "title_evening" : "Good night",
        "subtitle" : "Check some recommendations",
        "card1_title" : "Make a Call",
        "card1_subtitle" : "Call your friends",
        "card1_button" : "Call now",
        "card2_title" : "Add Contact",
        "card2_subtitle" : "Save a contact",
        "card2_button" : "Add contact"
      },

      "Profile" : {
        "title" : "Creating Your Profile",
        "subtitle" : "Tell Us About You",
        "subtitle2" : "We need your name before continue",
        "button" : "Save profile"
      },

      "Settings" : {
        "title" : "My Settings",
        "card1_title" : "View Project Source Code",
        "card1_subtitle" : "Open the official GitHub page",
        "card2_title" : "Set UI Language",
        "card2_subtitle" : "Choose your default language",
        "card3_title" : "Change your name",
        "card3_subtitle" : "Reset your profile",
        "card4_title" : "Rate Us",
        "card4_subtitle" : "Rate this App on Google Play Store",
        "card5_title" : "About Material Dialer",
        "card5_subtitle" : "Check App details",
        "card6_title" : "Read Security Policy",
        "card6_subtitle" : "Latest application policy for users"
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
        "toaster3" : "Downloading a new update!\nPlease, don't close the app",
        "downloading_title" : "Downloading Latest Release",
        "downloading_subtitle" : "Installed Version",
        "downloading_subtitle2" : "Latest Version",
        "downloading_progress" : "Downloading",
        "downloading_button" : "Install",
        "downloading_warning" : "Please, don't close the application\nuntil the installation succeeds"

      },

      "Contacts" : {
        "title" : "My Contacts",
        "button1" : "Create Contact",
        "button2" : "Pick a Contact",
        "toaster" : "Saved your contact",
        "menu_button" : "Import Contacts",
        "menu_button_2" : "Export Contacts",
        "empty" : "Nothing here, just leafs",
        "export" : "Exported your current contacts to the path",
        "import" : "Restored your contacts!"
      },

      "CreateContact" : {
        "title" : "Create Contact",
        "box1" : "Phone",
        "box2" : "Name",
        "button" : "Save Contact",
        "toaster" : "Saved your contact"
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

      "Home" : {
        "title_morning" : "Buenos días",
        "title_afternoon" : "Buenas tardes",
        "title_evening" : "Buenas noches",
        "subtitle" : "Aquí tienes algunas recomendaciones",
        "card1_title" : "Hacer Llamada",
        "card1_subtitle" : "Llama a tus amigos",
        "card1_button" : "Llamar ahora",
        "card2_title" : "Contactos",
        "card2_subtitle" : "Registrar contacto",
        "card2_button" : "Añadir contacto"
      },

      "Profile" : {
        "title" : "Creando Tu Perfil",
        "subtitle" : "Cuéntanos Sobre Ti",
        "subtitle2" : "Necesitamos tu nombre antes de continuar",
        "button" : "Guardar perfil"
      },

      "Settings": {
        "title": "Mis Ajustes",
        "card1_title": "Ver código fuente del programa",
        "card1_subtitle": "Abrir la página oficial de GitHub",
        "card2_title": "Cambiar idioma",
        "card2_subtitle": "Selecciona tu idioma por defecto",
        "card3_title": "Cambia tu nombre",
        "card3_subtitle": "Reestablece tu perfil",
        "card4_title": "Danos una puntuación",
        "card4_subtitle": "Puntua esta aplicación en Google Play Store",
        "card5_title": "Sobre Material Dialer",
        "card5_subtitle": "Ver detalles de la aplicación",
        "card6_title" : "Leer poliza de seguridad",
        "card6_subtitle" : "Última poliza de aplicación para los usuarios",
      },

      "About": {
        "title" : "Sobre Material Dialer",
        "card1": "Nombre",
        "card2": "Versión",
        "card3": "Nombre de paquete",
        "card4": "Firma de compilación",
        "button" : "Buscar Actualizaciones",
        "toaster" : "Buscando actualizaciones\nPor favor, espera...",
        "toaster2" : "Estás en la última versión",
        "toaster3" : "Descargando una nueva actualización!\nPor favor, no cierre la app",
        "downloading_title" : "Descargando Última Versión",
        "downloading_subtitle" : "Versión Instalada",
        "downloading_subtitle2" : "Última Versión",
        "downloading_progress" : "Descargando",
        "downloading_button" : "Instalar",
        "downloading_warning" : "Por favor, no cierre la aplicación\nhasta completar la instalación"
      },

      "Contacts": {
        "title": "Mis Contactos",
        "button1": "Crear Contacto",
        "button2": "Añadir Contacto",
        "toaster" : "Se ha guardado tu contacto",
        "menu_button" : "Importar Contactos",
        "menu_button_2" : "Exportar Contactos",
        "empty" : "No hay nada, solo hojas",
        "export" : "Exportados tus contactos al directorio",
        "import" : "Restaurados tus contactos!"

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

      "Home" : {
        "title_morning" : "Bon matin",
        "title_afternoon" : "Bon après-midi",
        "title_evening" : "Bon Soir",
        "subtitle" : "Consultez quelques recommandations",
        "card1_title" : "Fais Téléphonee",
        "card1_subtitle" : "téléphoner vos amis",
        "card1_button" : "Téléphoner",
        "card2_title" : "Contacts",
        "card2_subtitle" : "Enregistrer un contact",
        "card2_button" : "Ajouter le contact"
      },

      "Profile" : {
        "title" : "Création Votre Profil",
        "subtitle" : "Parlez Nous De Vous",
        "subtitle2" : "Nous avons besoin de votre nom avant de continuer",
        "button" : "Enregistrer Profil"
      },


      "Settings" : {
        "title" : "Mes Paramètres",
        "card1_title" : "Afficher le code source du projet",
        "card1_subtitle" : "Ouvrez la page officielle GitHUb",
        "card2_title" : "Définir la langue de l'interface utilisateur",
        "card2_subtitle" : "Choisissez votre langue par défaut",
        "card3_title" : "Changez votre nom",
        "card3_subtitle" : "Réinitialiser votre profil",
        "card4_title" : "Évaluez nous",
        "card4_subtitle" : "Évaluez cette application sur Google Play Store",
        "card5_title" : "À propos du Material Dialer",
        "card5_subtitle" : "Vérifier les détails de l'application",
        "card6_title" : "Lire la politique de sécurité",
        "card6_subtitle" : "Dernière politique d'application pour les utilisateurs",
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
        "toaster3" : "Téléchargement d'une nouvelle mise à jour!\nS'il vous plaît, ne fermez pas l'application",
        "downloading_title" : "Téléchargement Dernière Version",
        "downloading_subtitle" : "Version installée",
        "downloading_subtitle2" : "Dernière version",
        "downloading_progress" : "Téléchargement",
        "downloading_button" : "Installer",
        "downloading_warning" : "Veuillez ne pas fermer l'application\ntant que l'installation n'a pas réussi"
      },

      "Contacts" : {
        "title" : "Mes Contacts",
        "button1" : "Créer contact",
        "button2" : "Choisissez contact",
        "toaster" : "Saved your contact",
        "menu_button" : "Contacts d'importation",
        "menu_button_2" : "Exporter des contacts",
        "empty" : "Rien ici, juste des feuilles",
        "export" : "Exporté vos contacts actuels vers le répertoire",
        "import" : "Restauré vos contacts!"
      },

      "CreateContact" : {
        "title" : "Créer un Contact",
        "box1" : "Téléphone",
        "box2" : "Nom",
        "button" : "Enregistrer le Contact",
        "toaster" : "Le contact a été enregistré"
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

      "Home" : {
        "title_morning" : "Buongiorno",
        "title_afternoon" : "Buone tarde",
        "title_evening" : "Buona Notte",
        "subtitle" : "Alcuni consigli",
        "card1_title" : "Effettuare Chiamata",
        "card1_subtitle" : "Chiama i tuoi amici",
        "card1_button" : "Chiamare",
        "card2_title" : "Contatti",
        "card2_subtitle" : "Registra un contatto",
        "card2_button" : "Aggiungi contatto"
      },


      "Profile" : {
        "title" : "Creazione Tuo Profilo",
        "subtitle" : "Raccontaci Di Te",
        "subtitle2" : "Abbiamo bisogno del tuo nome prima di continuare",
        "button" : "Salva Profilo"
      },

      "Settings" : {
        "title" : "Le mie Impostazioni",
        "card1_title" : "Visualizza il codice sorgente del progetto",
        "card1_subtitle" : "Apri la pagina ufficiale di GitHub",
        "card2_title" : "Imposta la lingua dell'interfaccia utente",
        "card2_subtitle" : "Scegli la tua lingua predefinita",
        "card3_title" : "Cambia il tuo nome",
        "card3_subtitle" : "Reimposta il tuo profilo",
        "card4_title" : "Valutaci",
        "card4_subtitle" : "Valuta questa app su Google Play Store",
        "card5_title" : "Informazioni su Material Dialer",
        "card5_subtitle" : "Controlla i dettagli dell'app",
        "card6_title" : "Leggi la politica di sicurezza",
        "card6_subtitle" : "Politica dell'applicazione più recente per gli utenti",
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
        "toaster3" : "Download di un nuovo aggiornamento!\nPer favore, non chiudere l'app",
        "downloading_title" : "Scaricando Ultima Versione",
        "downloading_subtitle" : "Versione Installata",
        "downloading_subtitle2" : "Ultima Versione",
        "downloading_progress" : "Scaricando",
        "downloading_button" : "Installare",
        "downloading_warning" : "Per favore, non chiudere l'applicazione\nfino a quando l'installazione non riesce"
      },

      "Contacts" : {
        "title" : "I miei Contatti",
        "button1" : "Crea Contatto",
        "button2" : "Scegli Contatto",
        "toaster" : "Saved your contact",
        "menu_button" : "Importa contatti",
        "menu_button_2" : "Esporta contatti",
        "empty" : "Niente qui, se ne va",
        "export" : "Hai esportato i tuoi contatti attuali nella directory",
        "import" : "Hai ripristinato i tuoi contatti!"
      },

      "CreateContact" : {
        "title" : "Crea Contatto",
        "box1" : "Telefono",
        "box2" : "Nome",
        "button" : "Salva Contatto",
        "toaster" : "Salvato il contatto"
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

      "Home" : {
        "title_morning" : "Guten Morgen",
        "title_afternoon" : "Guten Nachmittag",
        "title_evening" : "Guten Abend",
        "subtitle" : "Überprüfen Sie einige Empfehlungen",
        "card1_title" : "Anrufen",
        "card1_subtitle" : "Freunde anrufen",
        "card1_button" : "Jetzt anrufen",
        "card2_title" : "Kontakte",
        "card2_subtitle" : "Kontakt speichern",
        "card2_button" : "Hinzufügen"
      },

      "Profile" : {
        "title" : "Erstellung Ihres Profils",
        "subtitle" : "Erzähl Uns Von Dir",
        "subtitle2" : "Wir brauchen Ihren Namen, bevor Sie fortfahren",
        "button" : "Profil speichern"
      },

      "Settings" : {
        "title" : "Meine Einstellungen",
        "card1_title" : "Projektquellcode anzeigen",
        "card1_subtitle" : "Öffnen Sie die offizielle GitHub-Seite",
        "card2_title" : "Legen sie UI",
        "card2_subtitle" : "Wählen Sie Ihre Standardsprache",
        "card3_title" : "Ändere deinen Namen",
        "card3_subtitle" : "Setzen Sie Ihr Profil zurück",
        "card4_title" : "Bewerten Sie uns",
        "card4_subtitle" : "Bewerten Sie diese App im Google Play Store",
        "card5_title" : "Über Material Dialer",
        "card5_subtitle" : "Überprüfen Sie die App-Details",
        "card6_title": "Sicherheitsrichtlinie lesen",
        "card6_subtitle": "Neueste Anwendungsrichtlinie für Benutzer",
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
        "toaster3" : "Laden Sie ein neues Update herunter!\nBitte schließen Sie die App nicht",
        "downloading_title" : "Laden Neueste Version",
        "downloading_subtitle" : "Installierte Version",
        "downloading_subtitle2" : "Letzte Version",
        "downloading_progress" : "wird heruntergeladen",
        "downloading_button" : "Installieren",
        "downloading_warning" : "Bitte schließen Sie die Anwendung nicht\nbis die Installation erfolgreich ist"
      },

      "Contacts" : {
        "title" : "Meine Kontakte",
        "button1" : "Kontakt Erstellen",
        "button2" : "Wählen Sie einen Kontakt aus",
        "toaster" : "Saved your contact",
        "menu_button" : "Kontakte importieren",
        "menu_button_2" : "Kontakte exportieren",
        "empty" : "Nichts hier, nur Blätter",
        "export" : "Ihre aktuellen Kontakte in das Verzeichnis exportiert",
        "import" : "Ihre Kontakte wiederhergestellt!"
      },

      "CreateContact" : {
        "title" : "Kontakt Erstellen",
        "box1" : "Telefon",
        "box2" : "Name",
        "button" : "Kontakt speichern",
        "toaster" : "Kontakt gespeichert"

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
      user = jsonDecode(_jsonString);
      String str = user["color"];
      String name = user["name"];
      int value = int.parse(str, radix: 16);
      String nm = name.toString();
      Color otherColor = new Color(value);
      colors[0] = otherColor;
      this.name = nm;
      writeJson("color", otherColor);

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
        String name = user["name"];
        int value = int.parse(str, radix: 16);
        String nm = name.toString();
        Color otherColor = new Color(value);

        setState(() {
          colors[0] = otherColor;
          this.name = nm;
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

  void isStartColor(bool exist2) async {
    final emptyFile = File(
        "/data/user/0/com.daviiid99.material_dialer/app_flutter/empty.json");
    bool exists = await emptyFile.exists();


    if (exist2 == true && exists == false)  {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: SingleChildScrollView(

                  child: BlockPicker(
                      pickerColor: colors[0], //default color
                      onColorChanged: (Color color) { //on color picked
                        jsonFile = "user.json";
                        String colorString = color
                            .toString(); // Color(0x12345678)
                        String valueString = colorString.split('(0x')[1].split(
                            ')')[0]; // kind of hacky..
                        writeJson("color", valueString);
                        readJson();
                        Navigator.pop(context);
                      })
              ),
            );
          }
      );
    }
    File('/data/user/0/com.daviiid99.material_dialer/app_flutter/empty.json').writeAsString("w");
  }



  void isNewProfile() async{
    final path = await _localPath;
    final languagesFile = File("/data/user/0/com.daviiid99.material_dialer/app_flutter/user.json");

    bool exists = await languagesFile.exists();

    if (!exists) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              Profile(colors[mode_counter]),
          ));

    } else {
      isStartColor(exists);
    }

  }

  void isCleanInstall() async {

    final path = await _localPath;
    final languagesFile = File("/data/user/0/com.daviiid99.material_dialer/app_flutter/languages.json");

    bool exists = await languagesFile.exists();


    if (!exists) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              SetLanguage(mode_counter, modes, colors, fonts, currentLanguage,
                  language),
          ));
    } else {
      isNewProfile();
    }
  }

  @override
  void initState(){
    jsonFile = "languages.json";
    readJson();

    setState(() async {
      jsonFile = "languages.json";
      readJson();
      currentLanguage = language["language"];
      isCleanInstall();

      setTime = DateFormat('H' ).format(now);
      if (int.parse(setTime) >= 0 && int.parse(setTime) < 6)  setTime = "title_evening";
      else if (int.parse(setTime) >=6 && int.parse(setTime) < 12)  setTime = "title_morning";
      else if (int.parse(setTime) >=12 && int.parse(setTime) < 21)  setTime = "title_afternoon";
      else if (int.parse(setTime) >= 21 && int.parse(setTime) <  23)  setTime = "title_evening";

      super.initState();

      quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(type: 'callaction', localizedTitle: 'Make a Call'),
        ShortcutItem(type: 'contactaction', localizedTitle: 'Create a Contact'),
        ShortcutItem(type: 'settingsaction', localizedTitle: 'Change Settings'),
        ShortcutItem(type: 'updateaction', localizedTitle: 'Check for Updates')


      ]);

      quickActions.initialize((shortcutType) {
        if (shortcutType == 'callaction') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colors, fonts, currentLanguage, language, number, history)),
          );
        } else if(shortcutType == "contactaction"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language, history)),
          );
        }
        else if(shortcutType == "settingsaction"){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings(mode_counter, modes, colors, fonts, currentLanguage, language, index),
              ));
        }

        else if(shortcutType == "updateaction"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colors, fonts, currentLanguage, language)),
          );
        }

        // More handling code...
      });

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
    body: Column(
    children: <Widget>[
     SizedBox(height: 5,),
      Text(
         language[currentLanguage]["Home"][setTime] + ", " + "$name" + "\n",
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
      )
      ),

      Text(
        language[currentLanguage]["Home"]["subtitle"] + "\n",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,

        ),
      ),

      SizedBox(
        height: 220,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(language[currentLanguage]["Home"]["card1_title"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                         SizedBox(
                          height: 5,
                        ),
                         Text(language[currentLanguage]["Home"]["card1_subtitle"],
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)),
                         SizedBox(
                          height: 6,
                        ),
                        ElevatedButton(
                          //on pressed
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DialPadNumbers(mode_counter, modes, colors, fonts, currentLanguage, language, number, history)),
                            );
                          },
                          //text to shoe in to the button
                          child:  Text(language[currentLanguage]["Home"]["card1_button"],
                              style: TextStyle(color: Colors.white)),
                          //style section code here
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: 170,
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/images/call.png",
                fit: BoxFit.fitWidth,
                height: 300,
                width:  180,
                scale: 0.5,

              ),
            )
          ],
        ),
      ),

      SizedBox(
        height: 220,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.purpleAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(language[currentLanguage]["Home"]["card2_title"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                         SizedBox(
                          height: 5,
                        ),
                         Text(language[currentLanguage]["Home"]["card2_subtitle"],
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300)),
                         SizedBox(
                          height: 6,
                        ),
                        ElevatedButton(
                          //on pressed
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language, history)),
                            );
                          },
                          //text to shoe in to the button
                          child: Text(language[currentLanguage]["Home"]["card2_button"],
                              style: TextStyle(color: Colors.white)),
                          //style section code here
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: 170,
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/images/contact.png",
                fit: BoxFit.fitWidth,
                height: 235,
                width: 200,

              ),
            )
          ],
        ),
      ),

    ]
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


