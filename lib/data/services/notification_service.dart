import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsync_meetup_app/data/models/notification_model.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final List<NotificationModel> _notifications = [];
  static const String _prefsKey = 'notification_preferences';

  NotificationService({FirebaseMessaging? firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      // Request notification permissions
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('Notification permissions: ${settings.authorizationStatus}');

      // Get and log FCM token
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received foreground message: ${message.messageId}');
        final notification = NotificationModel.fromRemoteMessage(message);
        _addNotification(notification);
      });

      // Handle background messages (iOS/Android)
      FirebaseMessaging.onBackgroundMessage(_firebaseMessageHandler);

    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      rethrow;
    }
  }

  Future<void> _firebaseMessageHandler(RemoteMessage message) async {
    debugPrint('Handling background message: ${message.messageId}');
    final notification = NotificationModel.fromRemoteMessage(message);
    _addNotification(notification);
  }

  void _addNotification(NotificationModel notification) {
    _notifications.insert(0, notification); // Newest first
    // Here you could add notification to persistent storage
  }

  Future<List<NotificationModel>> getNotifications() async {
    // Sort by createdAt descending (newest first)
    _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(_notifications); // Return immutable copy
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      // Here you could update persistent storage
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
      rethrow;
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
      rethrow;
    }
  }

  /// Gets the notification preference for a user
  Future<bool> getNotificationPreference(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_prefsKey$userId') ?? true; // Default to true
    } catch (e) {
      debugPrint('Error getting notification preference: $e');
      return true; // Fallback to enabled
    }
  }

  /// Sets the notification preference for a user
  Future<void> setNotificationPreference(String userId, bool isEnabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_prefsKey$userId', isEnabled);
      debugPrint('Notification preference set to $isEnabled for user $userId');
    } catch (e) {
      debugPrint('Error setting notification preference: $e');
      rethrow;
    }
  }

  // For testing/debugging
  Future<void> clearAllNotifications() async {
    _notifications.clear();
  }
}