// new_password_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email; // Add this if you need to receive the email
  
  const NewPasswordScreen({
    super.key,
    required this.email, // Add this parameter
  });

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set New Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Reset password for ${widget.email}'), // Display the email if needed
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }
                
                // Handle password reset logic here
                // Then navigate to home or login screen
                context.goNamed('login');
              },
              child: const Text('Reset Password'),
            )
          ],
        ),
      ),
    );
  }
}