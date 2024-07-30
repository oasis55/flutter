import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/database_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.currentUserId
  });

  final String currentUserId;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEdit = false;
  late User _user;
  String? _avatarUrl;
  String? _name;
  late final DatabaseService _db;
  late final TextEditingController _textFieldController;

  void _editTrigger() async {
    setState(() {
      _isEdit = !_isEdit;
    });
    if (_isEdit == false) {
      await _db.updateUser(User(id: _user.id, displayName: _textFieldController.text, photoUrl: _user.photoUrl));
      _loadUser();
    }
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    var imageFile = File(image!.path);
    Reference ref = FirebaseStorage.instance.ref().child("images").child(image.name);
    await ref.putFile(imageFile);
    final downloadURL = await ref.getDownloadURL();

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('avatarURL', downloadURL);

    await _db.updateUser(User(id: _user.id, displayName: _user.displayName, photoUrl: downloadURL));

    _loadAvatar();
  }

  void _loadAvatar() async {
    final SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    final String? avatarUrl = sharedPreference.getString('avatarURL');

    if (avatarUrl != null) {
      setState(() {
        _avatarUrl = avatarUrl;
      });
    }
  }

  void _loadUser() async {
    User? user = await _db.getCurrentUser();

    if (user == null) {
      try {
        await _db.updateUser(User(
          id: widget.currentUserId,
          displayName: 'no_name',
          photoUrl: null
        ));
        _loadUser();
      } catch(error) {
        // some action
      }
    } else {
      setState(() {
        _user = user;
        _name = user.displayName;
        _avatarUrl = user.photoUrl;
        _textFieldController.text = user.displayName ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _db = DatabaseService(userId: widget.currentUserId);
    _textFieldController = TextEditingController();
    _loadUser();
    _loadAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: _editTrigger,
            child: Text(_isEdit ? 'Done' : 'Edit'),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _avatarUrl != null
                ? Image.network(_avatarUrl ?? '')
                : const CircleAvatar(backgroundImage: AssetImage('assets/man.png'), radius: 32,)
            ),
            const SizedBox(height: 16,),
            _isEdit
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: TextField(
                      controller: _textFieldController,
                    ),
                  )
                : Text(_name ?? 'no_name', style: const TextStyle(fontSize: 24),)
          ],
        ),
      ),
    );
  }
}
