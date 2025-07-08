import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsync_meetup_app/data/models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats/$chatId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage(String chatId, String text, String senderId) async {
    await _firestore.collection('chats/$chatId/messages').add({
      'text': text,
      'senderId': senderId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}