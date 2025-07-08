// lib/logic/settings/settings_state.dart
abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final bool darkMode;
  final bool notificationsEnabled;

  const SettingsLoaded({
    required this.darkMode,
    required this.notificationsEnabled,
  });

  SettingsLoaded copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
  }) {
    return SettingsLoaded(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
}
