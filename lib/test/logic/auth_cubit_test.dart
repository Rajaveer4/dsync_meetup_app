import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:dsync_meetup_app/data/services/auth_service.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService extends Mock implements AuthService {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockAuthService mockAuthService;
  late MockSharedPreferences mockSharedPreferences;
  late AuthCubit authCubit;

  final testUser = User(
    id: '123',
    name: 'Test User',
    email: 'test@example.com',
    provider: 'google',
    isActive: true,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAuthService = MockAuthService();
    mockSharedPreferences = MockSharedPreferences();
    authCubit = AuthCubit(mockAuthService, mockSharedPreferences);
  });

  tearDown(() {
    authCubit.close();
  });

  group('Initial State', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });
  });

  group('Google Sign-In', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, Authenticated] when successful',
      build: () => authCubit,
      setUp: () {
        when(() => mockAuthService.signInWithGoogle()).thenAnswer((_) async => testUser);
      },
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        isA<AuthLoading>(),
        isA<Authenticated>(),
      ],
      verify: (_) {
        verify(() => mockAuthService.signInWithGoogle()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when failed',
      build: () => authCubit,
      setUp: () {
        when(() => mockAuthService.signInWithGoogle())
            .thenThrow(Exception('Sign in failed'));
      },
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );
  });

  group('Sign Out', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, Unauthenticated] when called',
      build: () => authCubit,
      setUp: () {
        when(() => mockAuthService.signOut()).thenAnswer((_) async {});
        when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ],
      verify: (_) {
        verify(() => mockAuthService.signOut()).called(1);
        verify(() => mockSharedPreferences.remove(AuthCubit.onboardingKey)).called(1);
      },
    );
  });

  group('Check Auth State', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, Authenticated] when user is logged in',
      build: () => authCubit,
      setUp: () {
        when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => testUser);
        when(() => mockSharedPreferences.getBool(any())).thenReturn(false);
      },
      act: (cubit) => cubit.checkAuthState(),
      expect: () => [
        isA<AuthLoading>(),
        isA<Authenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, Unauthenticated] when no user is logged in',
      build: () => authCubit,
      setUp: () {
        when(() => mockAuthService.getCurrentUser()).thenAnswer((_) async => null);
      },
      act: (cubit) => cubit.checkAuthState(),
      expect: () => [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ],
    );
  });

  group('Complete Onboarding', () {
    blocTest<AuthCubit, AuthState>(
      'should update state with onboarding completed',
      build: () => authCubit,
      setUp: () {
        when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
        authCubit.emit(Authenticated(testUser));
      },
      act: (cubit) => cubit.completeOnboarding(),
      expect: () => [
        isA<Authenticated>().having(
          (s) => s.hasCompletedOnboarding,
          'hasCompletedOnboarding',
          true,
        ),
      ],
      verify: (_) {
        verify(() => mockSharedPreferences.setBool(AuthCubit.onboardingKey, true)).called(1);
      },
    );
  });
}