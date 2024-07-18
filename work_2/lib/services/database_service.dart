import 'package:firebase_database/firebase_database.dart';
import 'package:work_2/models/message.dart';

class DatabaseService {
  DatabaseService({required this.id});

  FirebaseDatabase database = FirebaseDatabase.instance;

  final String id;

  Future sendMessage(text) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
    final message = Message(
        userId: id,
        text: text,
        timestamp: DateTime.now().microsecondsSinceEpoch.toString());

    final messageRef = ref.push();
    await messageRef.set(message.toJson());
  }
}
