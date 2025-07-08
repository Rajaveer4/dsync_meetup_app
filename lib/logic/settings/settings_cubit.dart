// lib/logic/settings/settings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/data/services/theme_service.dart';
import 'package:dsync_meetup_app/data/services/notification_service.dart';
import 'package:dsync_meetup_app/logic/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final ThemeService _themeService;
  final NotificationService _notificationService;
  final String userId;

  SettingsCubit({
    required ThemeService themeService,
    required NotificationService notificationService,
    required this.userId,
  })  : _themeService = themeService,
        _notificationService = notificationService,
        super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    try {
      final darkMode = await _themeService.getDarkMode(userId);
      final notificationsEnabled = 
          await _notificationService.getNotificationPreference(userId);
      emit(SettingsLoaded(
        darkMode: darkMode,
        notificationsEnabled: notificationsEnabled,
      ));
    } catch (e) {
      emit(SettingsError('Failed to load settings: ${e.toString()}'));
    }
  }

  Future<void> updateTheme(bool value) async {
    try {
      await _themeService.setDarkMode(userId, value);
      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(darkMode: value));
      }
    } catch (e) {
      emit(SettingsError('Failed to update theme: ${e.toString()}'));
    }
  }

  Future<void> updateNotifications(bool value) async {
    try {
      await _notificationService.setNotificationPreference(userId, value);
      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(notificationsEnabled: value));
      }
    } catch (e) {
      emit(SettingsError('Failed to update notifications: ${e.toString()}'));
    }
  }
}
