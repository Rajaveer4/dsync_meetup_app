import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:dsync_meetup_app/core/constants/route_names.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.goNamed(RouteNames.home); // e.g., home screen route
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ForgotPasswordSent) {
            context.go('/forgot-password');
          } else if (state is EmailVerificationRequired) {
            context.go('/verify-email');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome to DSync',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.register),
                  child: const Text("Don't have an account? Register"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Example: context.read<AuthCubit>().sendForgotPassword(email);
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
