class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}