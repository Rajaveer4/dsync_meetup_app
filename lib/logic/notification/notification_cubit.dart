import 'package:bloc/bloc.dart';
import 'package:dsync_meetup_app/data/services/notification_service.dart';
import 'package:dsync_meetup_app/logic/notification/notification_state.dart';
import 'package:dsync_meetup_app/core/utils/error_handler.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService notificationService;

  NotificationCubit(this.notificationService) : super(NotificationInitial());

  /// Fetch all notifications and emit state accordingly
  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await notificationService.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(ErrorHandler.handleError(e)));
    }
  }

  /// Mark a single notification as read and refresh the list
  Future<void> markAsRead(String notificationId) async {
    try {
      await notificationService.markAsRead(notificationId);
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updatedList = currentState.notifications.map((n) {
          if (n.id == notificationId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();
        emit(NotificationLoaded(updatedList));
      } else {
        // fallback fetch if current state is not loaded
        await fetchNotifications();
      }
    } catch (e) {
      emit(NotificationError(ErrorHandler.handleError(e)));
    }
  }

  /// Optional: Clear all notifications
  Future<void> clearNotifications() async {
    try {
      await notificationService.clearAllNotifications();
      emit(NotificationLoaded([]));
    } catch (e) {
      emit(NotificationError(ErrorHandler.handleError(e)));
    }
  }
}
