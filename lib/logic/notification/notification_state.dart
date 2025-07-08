import 'package:dsync_meetup_app/data/models/notification_model.dart';

/// Base class for all notification states
abstract class NotificationState {}

/// Initial (idle) state
class NotificationInitial extends NotificationState {}

/// Loading state for fetching/processing
class NotificationLoading extends NotificationState {}

/// Loaded state with list of notifications
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded(this.notifications);
}

/// Error state with message
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
