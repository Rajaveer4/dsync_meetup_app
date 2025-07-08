import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/settings/settings_cubit.dart';
import 'package:dsync_meetup_app/logic/settings/settings_state.dart';
import 'package:dsync_meetup_app/data/services/theme_service.dart';
import 'package:dsync_meetup_app/data/services/notification_service.dart';

class AdminSettings extends StatelessWidget {
  final String userId;

  const AdminSettings({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        themeService: ThemeService(),
        notificationService: NotificationService(),
        userId: userId,
      )..loadSettings(),
      child: const _AdminSettingsView(),
    );
  }
}

class _AdminSettingsView extends StatelessWidget {
  const _AdminSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SettingsCubit>().loadSettings();
            },
          ),
        ],
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: state.darkMode,
                  onChanged: (value) {
                    context.read<SettingsCubit>().updateTheme(value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Notifications'),
                  value: state.notificationsEnabled,
                  onChanged: (value) {
                    context.read<SettingsCubit>().updateNotifications(value);
                  },
                ),
              ],
            );
          }

          return const Center(child: Text('Failed to load settings.'));
        },
      ),
    );
  }
}
