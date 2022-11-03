import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'Contacts.dart';
import 'dart:convert';
import 'dart:io';
import 'Settings.dart';
import 'Contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'ManageMap.dart';
import 'History.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'SetLanguage.dart';
import 'Profile.dart';
import 'package:intl/intl.dart';
import 'package:quick_actions/quick_actions.dart';
import 'MaterialDIaler.dart';
import 'dart:math';
import 'Profile.dart';
import 'package:url_launcher/url_launcher.dart';


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
  late String number;
  String name = "";
  DateTime now = DateTime.now();
  String setTime = "";
  QuickActions quickActions = const QuickActions();
  double fontsize = 55;
  late String formattedDate;
  Random random = new Random();
  int randomNumber = 0;
  int randomNumber2 = 0;
  int randomNumber3 = 0;
  List<String> images = ["assets/images/call.png", "assets/images/contact.png", "assets/images/palette.png", "assets/images/lgs.png",  "assets/images/ota.png",  "assets/images/name.png", "assets/images/security.png", "assets/images/github.png", "assets/images/stars.png"];
  List<Color> colores = [Colors.green, Colors.purpleAccent, Colors.blueAccent, Colors.pink, Colors.brown, Colors.amber, Colors.red, Colors.blueGrey, Colors.deepOrange, Colors.teal];

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

      "UserMenu" : {
        "button1" : "General Settings",
        "button2" : "Set Language",
        "button3" : "Modify Profile",
        "button4" : "Choose Custom Theme",
        "button5" : "Reset App Data"
      },

      "Home" : {
        "title_morning" : "Good morning",
        "title_afternoon" : "Good afternoon",
        "title_evening" : "Good night",
        "subtitle" : "Recommendations",
        "card0_title" : "Make a Call",
        "card0_subtitle" : "Call your friends",
        "card0_button" : "Call now",
        "card1_title" : "Add Contact",
        "card1_subtitle" : "Save a contact",
        "card1_button" : "Add contact",
        "card2_title" : "Choose Theme",
        "card2_subtitle" : "Pick a color",
        "card2_button" : "Color picker",
        "card3_title" : "Set Language",
        "card3_subtitle" : "Change your language",
        "card3_button" : "Choose language",
        "card4_title" : "Check Updates",
        "card4_subtitle" : "Look for updates",
        "card4_button" : "Open updater",
        "card5_title" : "Reset Profile",
        "card5_subtitle" : "Modify your profile",
        "card5_button" : "Reet profile",
        "card6_title" : "Privacy Policy",
        "card6_subtitle" : "Check latest policy",
        "card6_button" : "View policy",
        "card7_title" : "Source Code",
        "card7_subtitle" : "Check source on GitHub",
        "card7_button" : "Check source",
        "card8_title" : "Rate Us",
        "card8_subtitle" : "Rate this app",
        "card8_button" : "Rate app"
      },

      "Profile" : {
        "title" : "Creating Your Profile",
        "subtitle" : "Tell Us About You",
        "subtitle2" : "We need your name before continue",
        "button" : "Save profile",
        "button2" : "Choose picture",
        "subtitle_picture" : "Set Your Profile Picture",
        "subtitle_picture2" : "Choose a picture before continue"
      },

      "Settings" : {
        "title" : "My Settings",
        "card1_title" : "View Project Source Code",
        "card1_subtitle" : "Open the official GitHub page",
        "card2_title" : "Set UI Language",
        "card2_subtitle" : "Choose your default language",
        "card3_title" : "Change your profile",
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


      "EditContact" : {
        "image" : "Set Picture",
        "input1" : "Name",
        "input2" : "Number",
        "button1" : "Call",
        "button2" : "Update",
        "button3" : "Delete",
        "button4" : "Export"
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
        "subtitle" : "Last Calls",
        "menu1" : "Import History",
        "menu2" : "Export History",
        "menu3" : "Erase History"
      }

    },


    "Español" : {

      "UserMenu" : {
        "button1" : "Configuración General",
        "button2" : "Elegir Idioma",
        "button3" : "Modificar Perfil",
        "button4" : "Elegir Tema Personalizado",
        "button5" : "Reestablecer Aplicación"
      },

      "Home" : {
        "title_morning" : "Buenos días",
        "title_afternoon" : "Buenas tardes",
        "title_evening" : "Buenas noches",
        "subtitle" : "Recomendaciones",
        "card0_title" : "Hacer Llamada",
        "card0_subtitle" : "Llama a tus amigos",
        "card0_button" : "Llamar ahora",
        "card1_title" : "Contactos",
        "card1_subtitle" : "Registrar contacto",
        "card1_button" : "Añadir contacto",
        "card2_title" : "Elegir Tema",
        "card2_subtitle" : "Escoge un color",
        "card2_button" : "Seleccionar color",
        "card3_title" : "Elegir Idioma",
        "card3_subtitle" : "Cambia tu idioma",
        "card3_button" : "Seleccionar idioma",
        "card4_title" : "Buscar OTA",
        "card4_subtitle" : "Busca actualizaciones",
        "card4_button" : "Abrir actualizador",
        "card5_title" : "Elegir Perfil",
        "card5_subtitle" : "Modifica tu perfil",
        "card5_button" : "Reestablecer perfil",
        "card6_title" : "Poliza Privacidad",
        "card6_subtitle" : "Consulta la última poliza",
        "card6_button" : "Ver Poliza",
        "card7_title" : "Código Fuente",
        "card7_subtitle" : "Ver código en GitHub",
        "card7_button" : "Ver fuente",
        "card8_title" : "Puntúanos",
        "card8_subtitle" : "Puntúa la aplicación",
        "card8_button" : "Puntuar app"

      },

      "Profile" : {
        "title" : "Creando Tu Perfil",
        "subtitle" : "Cuéntanos Sobre Ti",
        "subtitle2" : "Necesitamos tu nombre antes de continuar",
        "button" : "Guardar perfil",
        "button2" : "Elegir imagen",
        "subtitle_picture" : "Establece Foto De Perfil",
        "subtitle_picture2" : "Elige una foto antes de continuar"
      },

      "Settings": {
        "title": "Mis Ajustes",
        "card1_title": "Ver código fuente del programa",
        "card1_subtitle": "Abrir la página oficial de GitHub",
        "card2_title": "Cambiar idioma",
        "card2_subtitle": "Selecciona tu idioma por defecto",
        "card3_title": "Cambia tu perfil",
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

      "EditContact" : {
        "image" : "Cambiar Foto",
        "input1" : "Nombre",
        "input2" : "Número",
        "button1" : "Llamar",
        "button2" : "Actualizar",
        "button3" : "Borrar",
        "button4" : "Exportar"
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
        "subtitle" : "Últimas Llamadas",
        "menu1" : "Importar Historial",
        "menu2" : "Exportar Historial",
        "menu3" : "Borrar Historial"
      }

    },

    "Français" : {

      "UserMenu": {
        "button1" : "Paramètres Généraux",
        "button2" : "Définir Langue",
        "button3" : "Modifier Profil",
        "button4" :  "Choisir Thème Personnalisé",
        "button5" : "Réinitialiser L'application"
      },

      "Home" : {
        "title_morning" : "Bon matin",
        "title_afternoon" : "Bon après-midi",
        "title_evening" : "Bon Soir",
        "subtitle" : "Recommandations",
        "card0_title" : "Fais Téléphonee",
        "card0_subtitle" : "téléphoner vos amis",
        "card0_button" : "Téléphoner",
        "card1_title" : "Contacts",
        "card1_subtitle" : "Enregistrer un contact",
        "card1_button" : "Ajouter le contact",
        "card2_title": "Choisir Thème",
        "card2_subtitle": "Choisissez une couleur",
        "card2_button": "Sélecteur de couleurs",
        "card3_title": "Définir Langue",
        "card3_subtitle": "Changez votre langue",
        "card3_button": "Choisir la langue",
        "card4_title": "Vérifier OTA",
        "card4_subtitle": "Rechercher les mises à jour",
        "card4_button": "Ouvrir OTA",
        "card5_title": "Définissez Votre Nom",
        "card5_subtitle": "Modifiez votre profil",
        "card5_button" : "Définir le profil",
        "card6_title": "Politique Confidentialité",
        "card6_subtitle": "Vérifier la dernière politique",
        "card6_button": "Afficher politique",
        "card7_title": "Code Source",
        "card7_subtitle": "Vérifiez source sur GitHub",
        "card7_button": "Vérifier source",
        "card8_title": "Évaluez-nous",
        "card8_subtitle": "Notez cette application",
        "card8_button": "Évaluer l'application"
      },

      "Profile" : {
        "title" : "Création Votre Profil",
        "subtitle" : "Parlez Nous De Vous",
        "subtitle2" : "Nous avons besoin de votre nom avant de continuer",
        "button" : "Enregistrer Profil",
        "button2": "Choisir image",
        "subtitle_picture": "Définissez Votre Image",
        "subtitle_picture2" : "Choisissez une image avant de continuer"
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

      "EditContact" : {
        "image": "Définir l'image",
        "input1": "Nom",
        "input2": "Numéro",
        "button1": "Appeler",
        "button2": "Mettre à jour",
        "button3": "Supprimer",
        "button4" : "Exporter"
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
        "subtitle" : "Dernier Appels Téléphoniques",
        "menu1": "Historique Importations",
        "menu2": "Exporter L'historique",
        "menu3": "Effacer L'historique"
      }

    },

    "Italiano" : {

      "UserMenu" : {
        "button1" : "Impostazioni Generali",
        "button2" : "Imposta Lingua",
        "button3" : "Modifica Profilo",
        "button4" : "Scegli Tema Personalizzato",
        "button5" : "Ripristina Dati App"
      },

      "Home" : {
        "title_morning" : "Buongiorno",
        "title_afternoon" : "Buone tarde",
        "title_evening" : "Buona Notte",
        "subtitle" : "Consigli",
        "card0_title" : "Effettuare Chiamata",
        "card0_subtitle" : "Chiama i tuoi amici",
        "card0_button" : "Chiamare",
        "card1_title" : "Contatti",
        "card1_subtitle" : "Registra un contatto",
        "card1_button" : "Aggiungi contatto",
        "card2_title" : "Scegli tema",
        "card2_subtitle" : "Scegli un colore",
        "card2_button" : "Selettore colore",
        "card3_title" : "Imposta Lingua",
        "card3_subtitle" : "Cambia la tua lingua",
        "card3_button" : "Scegli la lingua",
        "card4_title" : "Verifica Aggiornamenti",
        "card4_subtitle" : "Cerca aggiornamenti",
        "card4_button" : "Apri programma di aggiornamento",
        "card5_title" : "Imposta Il Tuo Nome",
        "card5_subtitle" : "Modifica il tuo profilo",
        "card5_button" : "Imposta profilo",
        "card6_title" : "Informativa Privacy",
        "card6_subtitle" : "Controlla l'ultima politica",
        "card6_button" : "Visualizza politica",
        "card7_title" : "Codice Sorgente",
        "card7_subtitle" : "Controlla GitHub",
        "card7_button" : "Controlla sorgente",
        "card8_title" : "Votaci",
        "card8_subtitle" : "Valuta questa app",
        "card8_button" : "Valuta app"
      },


      "Profile" : {
        "title" : "Creazione Tuo Profilo",
        "subtitle" : "Raccontaci Di Te",
        "subtitle2" : "Abbiamo bisogno del tuo nome prima di continuare",
        "button" : "Salva Profilo",
        "button2" : "Scegli immagine",
        "subtitle_picture": "Imposta Immagine Profilo",
        "subtitle_picture2" : "Scegli un'immagine prima di continuare"
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

      "EditContact" : {
        "image" : "Imposta immagine",
        "input1" : "Nome",
        "input2" : "Numero",
        "button1" : "Chiama",
        "button2" : "Aggiorna",
        "button3" : "Elimina",
        "button4" : "Esporta"
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
        "subtitle" : "Ultime Chiamate",
        "menu1" : "Cronologia Importazione",
        "menu2" : "Esporta Cronologia",
        "menu3" : "Cancella Cronologia"
      }

    },

    "Deutsch" : {

      "UserMenu" : {
        "button1": "Allgemeine Einstellungen",
        "button2": "Sprache Einstellen",
        "button3": "Profil Ändern",
        "button4": "Benutzerdefiniertes Design Auswählen",
        "button5": "App-Daten Zurücksetzen"
      },

      "Home" : {
        "title_morning" : "Guten Morgen",
        "title_afternoon" : "Guten Nachmittag",
        "title_evening" : "Guten Abend",
        "subtitle" : "Empfehlungen",
        "card0_title" : "Anrufen",
        "card0_subtitle" : "Freunde anrufen",
        "card0_button" : "Jetzt anrufen",
        "card1_title" : "Kontakte",
        "card1_subtitle" : "Kontakt speichern",
        "card1_button" : "Hinzufügen",
        "card2_title": "Design Auswählen",
        "card2_subtitle": "Wähle eine Farbe",
        "card2_button": "Farbwähler",
        "card3_title": "Sprache Einstellen",
        "card3_subtitle": "Sprache ändern",
        "card3_button": "Sprache wählen",
        "card4_title": "Updates Prüfen",
        "card4_subtitle": "Nach Updates suchen",
        "card4_button": "Updater öffnen",
        "card5_title": "Setze Deinen Namen",
        "card5_subtitle" : "Ändern Sie Ihr Profil",
        "card5_button": "Profil festlegen",
        "card6_title": "Datenschutzrichtlinie",
        "card6_subtitle": "Neueste Richtlinie prüfen",
        "card6_button": "Richtlinie anzeigen",
        "card7_title": "Quellcode",
        "card7_subtitle": "Quelle GitHub Prüfen",
        "card7_button": "Quelle prüfen",
        "card8_title": "Bewerten Sie uns",
        "card8_subtitle": "Diese App bewerten",
        "card8_button": "App bewerten"
      },

      "Profile" : {
        "title" : "Erstellung Ihres Profils",
        "subtitle" : "Erzähl Uns Von Dir",
        "subtitle2" : "Wir brauchen Ihren Namen, bevor Sie fortfahren",
        "button" : "Profil speichern",
        "button2": "Bild auswählen",
        "subtitle_picture": "Stellen Bild Profilbild",
        "subtitle_picture2": "Wählen Sie ein Bild aus, bevor Sie fortfahren"
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

      "EditContact" : {
        "image": "Bild einstellen",
        "input1": "Name",
        "input2": "Nummer",
        "button1": "Anrufen",
        "button2": "Aktualisieren",
        "button3": "Löschen",
        "button4" : "Exportieren"
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
        "subtitle" : "Letzte Anrufe",
        "menu1": "Verlauf Importieren",
        "menu2": "Verlauf Exportieren",
        "menu3": "Verlauf Löschen"
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

        if(jsonFile.contains("history.json")){
          _jsonString = await _filePath.readAsString();
          history = jsonDecode(_jsonString);
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

    else if (jsonFile == "history.json"){
      history.addAll(_newJson);
      _jsonString = jsonEncode(history);
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

  void isProfilePicture(bool exists2) async{
    final imageExist = File('/data/user/0/com.daviiid99.material_dialer/app_flutter/image.json');
    bool exist = await imageExist.exists();

    if (exist == false){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePhoto(language, currentLanguage, colores[mode_counter]),
          ));

    } else {
      isStartColor(exists2);
    }
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
      isProfilePicture(exists);
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

  String addNumber(String numero, String full){

    setState(() {
      if(full.length == 3) {
        full += " ";
      }
      else if(full.length == 6){
        full += " ";
      } else if (full.length == 9){
        full += " ";
      }

      full += numero;

    });

    return full ;
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
      font = 35;
    }

    return font;

  }

  String removeCharacter(String numero){
    var str = "";
    str = numero.substring(0, numero.length - 1);
    return str ;
  }

  void llamar(String telefono) async{
    await FlutterPhoneDirectCaller.callNumber("$telefono");
  }

  _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    await launchUrl(_url,mode: LaunchMode.externalApplication);
  }

  void dialPad() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: SingleChildScrollView(
                  child: Column(
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(width: 45, height: 10,),
                              Text(number, style: TextStyle(
                                  fontSize: fontsize,
                                  color: fonts[mode_counter],
                                  decorationColor: Colors.black
                              ))
                            ],
                          ),


                        ),
                        FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("1"),
                                    focusColor: fonts[mode_counter],
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/1.mp3'));

                                      setState(() {
                                        number = addNumber(
                                            "1", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("2"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/2.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "2", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("3"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/3.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "3", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("4"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/4.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "4", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("5"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/5.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "5", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("6"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/6.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "6", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15,),

                        FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("7"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/7.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "7", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("8"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/8.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "8", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("9"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/9.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "9", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15,),

                        FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("+"),
                                    onPressed: () {
                                      setState(() {
                                        number = addNumber(
                                            "+", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Text("0"),
                                    onPressed: () {
                                      //player.play(AssetSource('sounds/0.mp3'));
                                      setState(() {
                                        number = addNumber(
                                            "0", number);
                                        fontsize = checkFont(
                                            number, fontsize);
                                      });
                                    },
                                  ),
                                ),
                              ), SizedBox(width: 15,),
                              SizedBox(
                                height: 110.0,
                                width: 110.0,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    backgroundColor: Colors
                                        .purple,
                                    child: Icon(
                                      Icons.backspace_outlined,
                                      color: Colors.white,),
                                    onPressed: () {
                                      //player.play(AssetSource('assets/sounds/del.mp3'));
                                      setState(() {
                                        number = removeCharacter(
                                            number);
                                        if (fontsize < 55) {
                                          fontsize += 3;
                                        }
                                      }
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30,),
                        FittedBox(

                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextButton.icon(
                                    label: Text(
                                      language[currentLanguage]["Calls"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.black),
                                      backgroundColor: Colors.green,fixedSize: const Size(340, 70),
                                      shape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                    jsonFile = "history.json";
                                    readJson();
                                    writeJson(number, formattedDate);
                                    llamar(number);

                                    setState((){
                                      number = "";
                                      fontsize = 45;
                                    });

                                     },
                                    icon: Icon(Icons.call, color: Colors.black,),
                                  ),

                                ]))
                      ]
                  )
              ),
            );
           },
          );
       }
    );
  }

  void generateRandomCard() async {
    int r1 = 0, r2 = 0, r3 = 0;

    while (r1 == r2 || r1 == r3 ||  r2 == r3){
      r1 = random.nextInt(9);
      r2 = random.nextInt(9);
      r3 = random.nextInt(9);
    }

    setState(() async {
      randomNumber = r1;
      randomNumber2 = r2;
      randomNumber3 = r3;
    });
  }

  void showPalette() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: SingleChildScrollView(

                      child: BlockPicker(
                          pickerColor: colors[0], //default color
                          onColorChanged: (Color color) { //on color picked
                            setState(() async {
                              jsonFile = "user.json";
                              String colorString = color
                                  .toString(); // Color(0x12345678)
                              String valueString = colorString.split('(0x')[1]
                                  .split(')')[0]; // kind of hacky..
                              colors[mode_counter] = color;
                              writeJson("color", valueString);
                              restoreValues();
                              int i = 2;
                              while (i > 0) {
                                i -=1;
                                Navigator.pop(context);
                              }
                            });
                          })
                  ),
                );
              }
          );
        }
    );
  }

  @override
  void initState(){
    // Set full screen mode for an inmersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    jsonFile = "languages.json";
    readJson();

    setState(() async {
      jsonFile = "languages.json";
      readJson();
      currentLanguage = language["language"];
      isCleanInstall();
      formattedDate = DateFormat('EEE d MMM').format(now);

      generateRandomCard();

      setTime = DateFormat('H' ).format(now);
      if (int.parse(setTime) >= 0 && int.parse(setTime) < 6)  setTime = "title_evening";
      else if (int.parse(setTime) >=6 && int.parse(setTime) < 12)  setTime = "title_morning";
      else if (int.parse(setTime) >=12 && int.parse(setTime) < 21)  setTime = "title_afternoon";
      else if (int.parse(setTime) >= 21 && int.parse(setTime) <=  23)  setTime = "title_evening";

      super.initState();

      quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(type: 'callaction', localizedTitle: 'Make a Call'),
        ShortcutItem(type: 'contactaction', localizedTitle: 'Create a Contact'),
        ShortcutItem(type: 'settingsaction', localizedTitle: 'Change Settings'),
        ShortcutItem(type: 'updateaction', localizedTitle: 'Check for Updates')


      ]);

      quickActions.initialize((shortcutType) {
        if (shortcutType == 'callaction') {
          dialPad();
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

  void userMenu()  {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    backgroundColor: colors[mode_counter],
                    content: SingleChildScrollView(
                        child: Column(
                          children: [

                          CircleAvatar(
                          minRadius: 50,
                          maxRadius: 75,
                          backgroundColor: Colors.transparent,
                          child : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                               child: Image.file(File(user["photo"])),
                          )
                            ),

                            SizedBox(height: 30,),

                        Row(
                          children : [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(color: Colors.white),
                                backgroundColor: Colors.grey,
                                fixedSize: const Size(120, 120),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0),
                                ),
                              ),
                              icon: Icon(Icons.settings, color: Colors.white, size: 102,),
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Settings(mode_counter, modes, colors, fonts, currentLanguage, language, index),
                                    ))
                              }, label: Text(""),
                            ),

                            SizedBox(width: 20,),

                            TextButton.icon(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(color: Colors.white),
                                backgroundColor: Colors.indigoAccent,
                                fixedSize: const Size(120, 120),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0),
                                ),
                              ),
                              icon: Icon(Icons.language_rounded, color: Colors.white, size: 102,),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SetLanguage(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                )
                              }, label: Text(""),
                            ),
                            ]
                        ),

                            SizedBox(height: 30,),

                            Row(
                              children : [
                                TextButton.icon(
                              style: TextButton.styleFrom(
                              textStyle: TextStyle(color: Colors.white),
                              backgroundColor: Colors.purple,
                              fixedSize: const Size(120, 120),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0),
                              ),
                                ),
                              icon: Icon(Icons.face_rounded, color: Colors.white, size: 102,),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Profile(colors[mode_counter])),
                                )
                              }, label: Text(""),
                            ),
                              SizedBox(width: 20,),

                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.pink,
                                  fixedSize: const Size(120, 120),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0),
                                  ),
                                ),
                                icon: Icon(Icons.palette_rounded, color: Colors.white, size: 102,),
                                onPressed: () async {
                                   showPalette();
                                }, label: Text(""),
                              ),
                            ]
                            ),
                          ],

                        )));
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: colors[mode_counter],
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
        children : <Widget>[
          Align(
            alignment: Alignment.center,
          ),
        InkWell(
            onTap: () => userMenu(),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: SizedBox(
              width: 60,
              height: 60,
              child: ClipOval(
        child: Image.file(File(user["photo"]), fit: BoxFit.cover,),
        ),
              )))]),
        backgroundColor: colors[mode_counter],
      ),
    body: Column(
    children: <Widget>[
     SizedBox(height: 10,),
      Text(
         language[currentLanguage]["Home"][setTime] ,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      )
      ),

      Text(
        "$name" + "\n",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )
      ),

    Text(
          "\n" + language[currentLanguage]["Home"]["subtitle"] ,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
        ),
      ),
      Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      color: colores[randomNumber],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(language[currentLanguage]["Home"]["card" + randomNumber.toString() + "_title"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(language[currentLanguage]["Home"]["card" + randomNumber.toString() + "_subtitle"],
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
                                  if (randomNumber == 0){
                                    dialPad();
                                  } else if (randomNumber == 1){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language, history)),
                                    );
                                  } else if (randomNumber == 2){
                                    showPalette();

                                  } else if (randomNumber == 3){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SetLanguage(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                    );
                                  } else if (randomNumber == 4){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                    );
                                  } else if (randomNumber == 5){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Profile(colors[mode_counter])),
                                    );
                                  } else if (randomNumber == 6){
                                    _launchURL("https://daviiid99.github.io/Material_Dialer/privacy.html");
                                  } else if (randomNumber == 7){
                                    _launchURL("https://github.com/daviiid99/Material_Dialer");
                                  } else if (randomNumber == 8){
                                    _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.material_dialer");
                                  }
                                },
                                //text to shoe in to the button
                                child:  Text(language[currentLanguage]["Home"]["card" + randomNumber.toString() + "_button"],
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
                      images[randomNumber],
                      fit: BoxFit.fitWidth,
                      height: 255,
                      width:  180,
                      scale: 0.8,

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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      color: colores[randomNumber2],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(language[currentLanguage]["Home"]["card" + randomNumber2.toString() + "_title"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(language[currentLanguage]["Home"]["card" + randomNumber2.toString() + "_subtitle"],
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
                                  if (randomNumber2 == 0){
                                    dialPad();
                                  } else if (randomNumber2 == 1){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language, history)),
                                    );
                                  } else if (randomNumber2 == 2){
                                    showPalette();

                                  } else if (randomNumber2 == 3){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SetLanguage(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                    );
                                  } else if (randomNumber2 == 4){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                    );
                                  } else if (randomNumber2 == 5){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Profile(colors[mode_counter])),
                                    );
                                  }
                                  else if (randomNumber2 == 6){
                                    _launchURL("https://daviiid99.github.io/Material_Dialer/privacy.html");
                                  } else if (randomNumber2 == 7){
                                    _launchURL("https://github.com/daviiid99/Material_Dialer");
                                  } else if (randomNumber2 == 8){
                                    _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.material_dialer");
                                  }
                                },
                                //text to shoe in to the button
                                child: Text(language[currentLanguage]["Home"]["card" + randomNumber2.toString() + "_button"],
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
                      images[randomNumber2],
                      fit: BoxFit.fitWidth,
                      height: 255,
                      width: 180,
                      scale: 0.8,

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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0))),
                      color: colores[randomNumber3],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(language[currentLanguage]["Home"]["card" + randomNumber3.toString() + "_title"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(language[currentLanguage]["Home"]["card" + randomNumber3.toString() + "_subtitle"],
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
                                  if (randomNumber3 == 0){
                                    dialPad();
                                  } else if (randomNumber3== 1){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Contacts(mode_counter, modes, colors, fonts, currentLanguage, language, history)),
                                    );
                                  } else if (randomNumber3 == 2){
                                    showPalette();

                                  } else if (randomNumber3 == 3){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SetLanguage(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                    );
                                  } else if (randomNumber3 == 4){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MaterialDialer(mode_counter, modes, colors, fonts, currentLanguage, language)),
                                    );
                                  } else if (randomNumber3 == 5){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Profile(colors[mode_counter])),
                                    );
                                  }
                                  else if (randomNumber3 == 6){
                                    _launchURL("https://daviiid99.github.io/Material_Dialer/privacy.html");
                                  } else if (randomNumber3 == 7){
                                    _launchURL("https://github.com/daviiid99/Material_Dialer");
                                  } else if (randomNumber3 == 8){
                                    _launchURL("https://play.google.com/store/apps/details?id=com.daviiid99.material_dialer");
                                  }
                                },
                                //text to shoe in to the button
                                child: Text(language[currentLanguage]["Home"]["card" + randomNumber3.toString() + "_button"],
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
                      images[randomNumber3],
                      fit: BoxFit.fitWidth,
                      height: 255,
                      width: 180,
                      scale: 0.8,

                    ),
                  )
                ],
              ),
            ),

          ],
        ),
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
                setState(() async {
                  dialPad();
                },
                );
            }
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
            )
          ],
        ),
      );
  }
}


