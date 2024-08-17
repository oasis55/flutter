import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/message.dart';
import '../services/database_service.dart';
import '../widgets/input_area.dart';
import '../widgets/message_list.dart';
import '../widgets/shimmer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _textFieldController;

  @override
  void initState() {
    _textFieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Some Chat'),
      ),
      body: StreamBuilder(
        stream: GetIt.I<DatabaseService>().getMessagesRef().onValue,
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
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: snapshot.hasData ? MessageList(messageList: messageList,) : const Shimmer(),
          );
          },
      ),
      bottomNavigationBar: InputArea(
        controller: _textFieldController,
        onPressed: () {
          GetIt.I<DatabaseService>().addMessage(_textFieldController.text);
          _textFieldController.text = "";
        },
      ),
    );
  }
}
