import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_2/models/message.dart';
import 'package:work_2/services/database_service.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';
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
  final TextEditingController _textFieldController = TextEditingController();
  final DatabaseReference _dbMessagesRef = FirebaseDatabase.instance.ref("messages");

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
            final firebaseMessages = Map<dynamic, dynamic>. from(
                (snapshot. data!). snapshot.value as Map<dynamic, dynamic>
            );

            firebaseMessages.forEach((key, value) {
              final currentMessage = Map<String, dynamic>.from(value);
              messageList.add(Message.fromMap(currentMessage));
            });

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                reverse: true,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              messageList[index].userId.substring(0, 8),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(StringToHex.toColor(messageList[index].userId))
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              timeago.format(
                                DateTime.fromMicrosecondsSinceEpoch(int.parse(messageList[index].timestamp))
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black38,
                                fontSize: 13
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          messageList[index].text,
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  );
                }
              ),
            );
          }
          return const Text('No messages');
        },
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          children: [
            Expanded(
                child: BottomAppBar(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                )),
            IconButton(
                onPressed: () {
                  DatabaseService(id: widget.userId).sendMessage(_textFieldController.text);
                  _textFieldController.text = "";
                },
                icon: const Icon(Icons.send)
            )
          ],
        ),
      ),
    );
  }
}
