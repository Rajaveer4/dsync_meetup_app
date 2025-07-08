import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  Future<void> logLogin(User user) async {
    await _analytics.logLogin(loginMethod: user.provider);
    await _analytics.setUserId(id: user.id);
    await _analytics.setUserProperty(
      name: 'sign_up_method', 
      value: user.provider,
    );
  }

  Future<void> logEventView(Event event) async {
    await _analytics.logEvent(
      name: 'view_event',
      parameters: {
        'event_id': event.id,
        'event_title': event.title,
        'event_category': event.category,
        'event_location': event.location,
      },
    );
  }

  Future<void> logEventJoin(Event event) async {
    await _analytics.logEvent(
      name: 'join_event',
      parameters: {
        'event_id': event.id,
        'event_title': event.title,
        'event_category': event.category,
      },
    );
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<Map<String, dynamic>> getPopularEvents() async {
    // Implement actual analytics query in production
    return {
      'most_viewed': [],
      'most_joined': [],
      'trending': [],
    };
  }
}