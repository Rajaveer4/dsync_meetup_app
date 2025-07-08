part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final User user;
  final bool hasCompletedOnboarding;
  
  const Authenticated(this.user, {this.hasCompletedOnboarding = false});
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class UserProfileUpdated extends AuthState {
  final User user;
  const UserProfileUpdated(this.user);
}

class ForgotPasswordSent extends AuthState {
  final String email;
  const ForgotPasswordSent(this.email);
}

class EmailVerificationRequired extends AuthState {
  const EmailVerificationRequired();
}

