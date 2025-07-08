import 'package:firebase_messaging/firebase_messaging.dart'; // Add this import

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;
  final String? actionRoute;
  final Map<String, dynamic>? payload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.imageUrl,
    this.actionRoute,
    this.payload,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      createdAt: DateTime.now(),
      isRead: false,
      imageUrl: message.notification?.android?.imageUrl ?? 
               message.notification?.apple?.imageUrl,
      payload: message.data,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isRead: map['isRead'] as bool? ?? false,
      imageUrl: map['imageUrl'] as String?,
      actionRoute: map['actionRoute'] as String?,
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'actionRoute': actionRoute,
      'payload': payload,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? imageUrl,
    String? actionRoute,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionRoute: actionRoute ?? this.actionRoute,
      payload: payload ?? this.payload,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, isRead: $isRead)';
  }
}