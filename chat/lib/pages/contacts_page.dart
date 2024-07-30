import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/database_service.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    super.key,
    required this.currentUserId
  });

  final String currentUserId;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late final DatabaseService _db;
  List<User> _users = [];

  void _loadContacts() async {
    final users = await _db.getUserList();
    setState(() {
      _users = users;
    });
  }

  @override
  void initState() {
    super.initState();
    _db = DatabaseService(userId: widget.currentUserId);
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(child: Text((_users[index].displayName ?? '').substring(0, 1))),
            title: Text(_users[index].displayName ?? '', style: const TextStyle(fontFamily: "KalniaGlaze"),),
          );
        }
      ),
    );
  }
}