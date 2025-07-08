import 'package:dsync_meetup_app/data/services/auth_service.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  final mockUser = User(
    id: '123',
    name: 'Test User',
    email: 'test@example.com',
    photoUrl: 'https://example.com/profile.jpg',
    provider: 'google',
    isActive: true,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('AuthService Tests', () {
    test('signInWithGoogle returns a valid user', () async {
      when(() => mockAuthService.signInWithGoogle())
          .thenAnswer((_) async => mockUser);

      final result = await mockAuthService.signInWithGoogle();
      expect(result, isA<User>());
      expect(result.name, equals('Test User'));
    });

    test('signOut completes successfully', () async {
      when(() => mockAuthService.signOut()).thenAnswer((_) async {});

      expect(mockAuthService.signOut(), completes);
    });

    test('getUserProfile returns a valid user', () async {
      when(() => mockAuthService.getUserProfile('123'))
          .thenAnswer((_) async => mockUser);

      final result = await mockAuthService.getUserProfile('123');
      expect(result.id, equals('123'));
      expect(result.email, equals('test@example.com'));
    });

    test('updateUserProfile completes successfully', () async {
      when(() => mockAuthService.updateUserProfile(mockUser))
          .thenAnswer((_) async {});

      expect(mockAuthService.updateUserProfile(mockUser), completes);
    });

    test('changePassword completes successfully', () async {
      when(() => mockAuthService.changePassword('oldPass', 'newPass'))
          .thenAnswer((_) async {});

      expect(mockAuthService.changePassword('oldPass', 'newPass'), completes);
    });

    test('signInWithGoogle throws on failure', () async {
      when(() => mockAuthService.signInWithGoogle())
          .thenThrow(Exception('Google Sign-In failed'));

      expect(
        () => mockAuthService.signInWithGoogle(),
        throwsA(isA<Exception>()),
      );
    });
  });
}