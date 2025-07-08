import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() => notificationsEnabled = value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Dark Mode'),
            value: darkModeEnabled,
            onChanged: (value) {
              setState(() => darkModeEnabled = value);
            },
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              // Save logic or show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings saved')),
              );
            },
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
