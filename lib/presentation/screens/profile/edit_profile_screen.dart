import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;
  final String? userId;
  final String? joinDate;
  final String? eventsAttended;  //change to optional

  const EditProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userId,
    this.joinDate,
    this.eventsAttended,
    this.profileImageUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.userEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(BuildContext context) async {
    // Here you would typically validate inputs and save to backend
    // Example:
    // await context.read<ProfileCubit>().updateProfile(
    //   name: _nameController.text,
    //   email: _emailController.text,
    //   image: _newProfileImage,
    // );
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    
    // Navigate back using GoRouter
    context.pop();
  }

  Future<void> _pickProfileImage() async {
    // Implement image picking logic
    // Example using image_picker:
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _newProfileImage = pickedFile.path;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(), // Go back without saving
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _newProfileImage != null
                    ? FileImage(File(_newProfileImage!)) as ImageProvider
                    : (widget.profileImageUrl != null
                        ? NetworkImage(widget.profileImageUrl!)
                        : const AssetImage('assets/default_profile.png')),
                child: _newProfileImage == null && widget.profileImageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap to change photo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _saveChanges(context),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}