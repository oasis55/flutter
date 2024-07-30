import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseService({required this.userId});

  FirebaseDatabase database = FirebaseDatabase.instance;

  final String userId;

  Future addMessage(text) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
    final message = Message(
        userId: userId,
        text: text,
        timestamp: DateTime.now().microsecondsSinceEpoch.toString()
    );

    final messageRef = ref.push();
    await messageRef.set(message.toJson());
  }
  
  Future addUser(User user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.id}");
    await ref.set(user.toJson());
  }

  Future updateUser(User user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.id}");
    await ref.update(user.toJson());
  }

  Future<User?> getCurrentUser() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId");
    final userRef = await ref.get();

    if (userRef.exists) {
      Map<String, dynamic> userMap = Map<String, dynamic>.from(userRef.value as Map);
      return User.fromJson(userMap);
    }

    return null;
  }

  Future<List<User>> getUserList() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    final userRef = await ref.get();
    final List<User> users = [];

    if (userRef.exists) {
      Map<String, dynamic> usersMap = Map<String, dynamic>.from(userRef.value as Map);
      usersMap.forEach((key, value) {
        users.add(
          User.fromJson(Map<String, dynamic>.from(value as Map))
        );
      });
    }

    return users;
  }
}
