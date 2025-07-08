import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';
import 'package:dsync_meetup_app/data/models/route_arguments.dart';
import 'package:intl/intl.dart';


class UserInfoPage extends StatelessWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime joinDate;
  final String? profileImageUrl;
  final int eventsAttended;

  const UserInfoPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.joinDate,
    required this.eventsAttended,
    this.profileImageUrl,
  });

  Future<void> _pickImage() async {
    // Implement image picking functionality
    // Example using image_picker:
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   // Handle the picked image
    // }
  }

  void _navigateToSettings(BuildContext context) {
    context.pushNamed(RouteNames.settings);
  }

  void _navigateToEvents(BuildContext context) {
    context.pushNamed(
      RouteNames.userEvents,
      extra: UserEventsArguments(userId: userId),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    context.pushNamed(
      RouteNames.editProfile,
      extra: EditProfileArguments(
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        joinDate: joinDate,
        eventsAttended: eventsAttended,
        profileImageUrl: profileImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              userName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Member since'),
              subtitle: Text(DateFormat('MMMM d, y').format(joinDate)),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events attended'),
              subtitle: Text('$eventsAttended'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _navigateToEvents(context),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _navigateToEditProfile(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}