import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_3/models/message.dart';
import 'package:work_3/services/database_service.dart';
import 'package:work_3/widgets/input_area.dart';
import 'package:work_3/widgets/message_list.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString('userId');

  if (userId == null) {
    final userId = uuid.v4();
    await prefs.setString('userId', userId);
    runApp(MyApp(userId: userId,));
    return;
  }

  runApp(MyApp(userId: userId,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Chat', userId: userId),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.userId});

  final String title;
  final String userId;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _textFieldController;
  late final DatabaseReference _dbMessagesRef;

  @override
  void initState() {
    _textFieldController = TextEditingController();
    _dbMessagesRef = FirebaseDatabase.instance.ref("messages");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _dbMessagesRef.onValue,
        builder: (context, snapshot) {
          List<Message> messageList = [];

          if (snapshot.hasData && snapshot.data != null && (snapshot.data!).snapshot.value != null) {
            final firebaseMessages = Map<dynamic, dynamic>.from(
                (snapshot.data!).snapshot.value as Map<dynamic, dynamic>
            );

            firebaseMessages.forEach((key, value) {
              final currentMessage = Map<String, dynamic>.from(value);
              messageList.add(Message.fromJson(currentMessage));
            });

            return MessageList(messageList: messageList,);
          }
          return const Text('No messages');
        },
      ),
      bottomNavigationBar: InputArea(
        controller: _textFieldController,
        onPressed: () {
          DatabaseService(id: widget.userId).sendMessage(_textFieldController.text);
          _textFieldController.text = "";
        },
      ),
    );
  }
}
