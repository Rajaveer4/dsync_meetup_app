import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:dsync_meetup_app/presentation/screens/auth/login_screen.dart';
import 'package:dsync_meetup_app/presentation/screens/home/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return _buildUI(context, state);
      },
    );
  }

  Widget _buildUI(BuildContext context, AuthState state) {
    switch (state.runtimeType) {
      case AuthInitial _:
      case AuthLoading _:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case Authenticated _:
        return const HomeScreen();
      case UserProfileUpdated _:
        return const HomeScreen();
      case AuthError _:
        return _buildErrorScreen(context, state as AuthError);
      case Unauthenticated _:
      default:
        return const LoginScreen();
    }
  }

  Widget _buildErrorScreen(BuildContext context, AuthError state) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.read<AuthCubit>().checkAuthState(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}