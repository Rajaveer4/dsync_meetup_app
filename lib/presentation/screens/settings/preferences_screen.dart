import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/theme_cubit.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: context.watch<ThemeCubit>().state.brightness == Brightness.dark,
            onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
          ),
          const ListTile(
            title: Text('Notification Settings'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            title: Text('Language'),
            subtitle: Text('English'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}