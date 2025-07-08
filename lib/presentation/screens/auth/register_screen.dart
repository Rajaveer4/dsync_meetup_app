import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:dsync_meetup_app/widgets/common/primary_button.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || !value.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value != null && value.length < 6 ? 'Min 6 chars required' : null,
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: 'Register',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          final success = await context.read<AuthCubit>().signUpWithEmail(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                          setState(() => isLoading = false);

                          if (success == true) {
                            // ✅ New user -> Go to onboarding
                            context.goNamed(RouteNames.onboarding);
                          } else {
                            // ❌ Registration failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration failed')),
                            );
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
