import 'package:chat/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Chats'),
        ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChatPage())
              );
            },
            child: const ListTile(
              leading: CircleAvatar(child: Text('A')),
              title: Text('Headline'),
              subtitle: Text('Supporting text'),
              trailing: Icon(Icons.favorite_rounded),
            ),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
