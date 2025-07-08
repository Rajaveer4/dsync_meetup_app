import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';
import 'package:dsync_meetup_app/data/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final SharedPreferences sharedPreferences;
  StreamSubscription? _authSubscription;

  static const onboardingKey = 'onboarding_completed'; // Add this line

  AuthCubit(this.authService, this.sharedPreferences) : super(AuthInitial()) {
    _init();
  }

  void _init() {
    // Start with loading state
    emit(AuthLoading());
    
    // Check initial auth state
    checkAuthState().then((_) {
      // Then listen for changes
      _authSubscription = authService.authStateChanges.listen(_handleAuthChange);
    });
  }

  void _handleAuthChange(User? user) async {
    if (user != null) {
      final onboardingCompleted = sharedPreferences.getBool(onboardingKey) ?? false;
      emit(Authenticated(user, hasCompletedOnboarding: onboardingCompleted));
    } else {
      emit(Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> completeOnboarding() async {
    if (state is! Authenticated) return;
    
    await sharedPreferences.setBool(onboardingKey, true);
    final currentState = state as Authenticated;
    emit(Authenticated(
      currentState.user,
      hasCompletedOnboarding: true,
    ));
  }

  Future<void> checkAuthState() async {
    if (state is AuthLoading) return;
    
    emit(AuthLoading());
    try {
      final user = await authService.getCurrentUser();
      if (user != null) {
        final onboardingCompleted = sharedPreferences.getBool(onboardingKey) ?? false;
        emit(Authenticated(user, hasCompletedOnboarding: onboardingCompleted));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await authService.signInWithGoogle();
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      await sharedPreferences.remove(onboardingKey);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    emit(AuthLoading());
    try {
      await authService.changePassword(oldPassword, newPassword);
      final user = await authService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      rethrow;
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    emit(AuthLoading());
    try {
      await authService.updateUserProfile(updatedUser);
      emit(Authenticated(updatedUser));
    } catch (e) {
      emit(AuthError(e.toString()));
      rethrow;
    }
  }

  Future<void> sendForgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await authService.sendPasswordResetEmail(email);
      emit(ForgotPasswordSent(email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkEmailVerification() async {
    emit(AuthLoading());
    try {
      final isVerified = await authService.isEmailVerified();
      if (isVerified) {
        final user = await authService.getCurrentUser();
        if (user != null) {
          final onboardingCompleted = sharedPreferences.getBool(onboardingKey) ?? false;
          emit(Authenticated(user, hasCompletedOnboarding: onboardingCompleted));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(EmailVerificationRequired());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void updateUserDetails({
    required String firstName,
    required String lastName,
    required String username,
    String? bio,
  }) async {
    if (state is! Authenticated) return;
    
    final currentState = state as Authenticated;
    final updatedUser = currentState.user.copyWith(
      name: '$firstName $lastName',
      username: username,
      bio: bio,
    );

    emit(AuthLoading());
    try {
      await authService.updateUserProfile(updatedUser);
      emit(Authenticated(updatedUser, hasCompletedOnboarding: currentState.hasCompletedOnboarding));
    } catch (e) {
      emit(AuthError(e.toString()));
      rethrow;
    }
  }

  Future<User> signUpWithEmail(String email, String password) async {
    final credential = await fb_auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final fbUser = credential.user!;
    // Adjust User constructor as per your user_model.dart
    final user = User(
      id: fbUser.uid,
      name: fbUser.displayName ?? '',
      email: fbUser.email ?? '',
      photoURL: fbUser.photoURL ?? '',
      provider: 'email',
      isActive: true,
      createdAt: DateTime.now(),
    );
    // Optionally, you can save the user to your backend or Firestore here
    return user;
  }
}