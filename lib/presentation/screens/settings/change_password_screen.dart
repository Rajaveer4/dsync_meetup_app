import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/settings/change_password_cubit.dart';
import 'package:dsync_meetup_app/logic/settings/change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChangePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().changePassword(
            _oldPasswordController.text,
            _newPasswordController.text,
            _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully')),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    decoration: const InputDecoration(labelText: 'Old Password'),
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter old password' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                    validator: (value) =>
                        value != _newPasswordController.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is ChangePasswordLoading ? null : _onChangePassword,
                    child: state is ChangePasswordLoading
                        ? const CircularProgressIndicator()
                        : const Text('Change Password'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
