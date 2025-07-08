import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _buildSettingsItem(
                  context,
                  title: 'Account Settings',
                  icon: Icons.account_circle,
                  routeName: RouteNames.accountSettings,
                ),
                const Divider(height: 1),
                _buildSettingsItem(
                  context,
                  title: 'Change Password',
                  icon: Icons.lock_outline,
                  routeName: RouteNames.changePassword,
                ),
              ],
            ),
          ),

          // Preferences Section
          _buildSectionHeader('Preferences'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _buildSettingsItem(
                  context,
                  title: 'Notification Settings',
                  icon: Icons.notifications,
                  routeName: RouteNames.notificationSettings,
                ),
                const Divider(height: 1),
                _buildSettingsItem(
                  context,
                  title: 'Privacy Settings',
                  icon: Icons.privacy_tip,
                  routeName: RouteNames.privacySettings,
                ),
              ],
            ),
          ),

          // App Section
          _buildSectionHeader('App'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _buildSettingsItem(
                  context,
                  title: 'Help & Support',
                  icon: Icons.help_outline,
                  routeName: RouteNames.help,
                ),
                const Divider(height: 1),
                _buildSettingsItem(
                  context,
                  title: 'About',
                  icon: Icons.info_outline,
                  routeName: RouteNames.about,
                ),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildLogoutButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String routeName,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        try {
          context.pushNamed(routeName);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not navigate to $title: $e')),
          );
        }
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade50,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => _showLogoutConfirmation(context),
      child: const Text('Log Out'),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              // Perform logout
              // context.read<AuthCubit>().logout();
              context.goNamed(RouteNames.login);
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}