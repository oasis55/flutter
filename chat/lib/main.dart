import 'package:chat/pages/chats_page.dart';
import 'package:chat/pages/contacts_page.dart';
import 'package:chat/pages/settings_page.dart';
import 'package:chat/pages/webview_page.dart';
import 'package:chat/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

String? userId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getString('userId');

  if (userId == null) {
    userId = const Uuid().v4();
    await prefs.setString('userId', userId ?? '');
  }

  GetIt.I.registerSingleton<DatabaseService>(DatabaseService(userId: userId as String));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: GoogleFonts.abel().fontFamily,
        useMaterial3: true,
      ),
      home: const MyHomePage(index: 0,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.index});

  final int index;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _routes = [
    const ContactsPage(),
    const ChatsPage(),
    const SettingsPage(),
    const WebViewPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _routes[widget.index],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyHomePage(index: index)
          ));
        },
        selectedIndex: widget.index,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.contacts), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
          NavigationDestination(icon: Icon(Icons.web), label: 'WebView'),
        ],
      ),
    );
  }
}
