import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:dsync_meetup_app/presentation/routes/app_router.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:dsync_meetup_app/logic/theme_cubit.dart';
import 'package:dsync_meetup_app/data/services/auth_service.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';

// Mock Classes
class MockAuthCubit extends Mock implements AuthCubit {}
class MockThemeCubit extends Mock implements ThemeCubit {}
class MockAuthService extends Mock implements AuthService {}
class MockNavigator extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Builds a testable widget with all necessary providers
Widget buildTestableWidget({
  required Widget child,
  AuthCubit? authCubit,
  ThemeCubit? themeCubit,
  AuthService? authService,
  bool withRouter = false,
}) {
  final mockAuthCubit = authCubit ?? MockAuthCubit();
  final mockThemeCubit = themeCubit ?? MockThemeCubit();
  final mockAuthService = authService ?? MockAuthService();

  // Setup default mock behaviors
  when(() => mockThemeCubit.state).thenReturn(ThemeData.light());
  when(() => mockAuthCubit.state).thenReturn(AuthInitial());

  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
      BlocProvider<AuthCubit>.value(value: mockAuthCubit),
      Provider<AuthService>.value(value: mockAuthService),
    ],
    child: withRouter
        ? MaterialApp.router(
            routerConfig: AppRouter(mockAuthCubit).router,
          )
        : MaterialApp(
            home: Scaffold(body: child),
          ),
  );
}

/// Pumps widget with simulated frame loading
Future<void> pumpWidgetWithSettling(
  WidgetTester tester,
  Widget widget, {
  Duration duration = const Duration(milliseconds: 100),
}) async {
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(duration);
}

/// Creates a mock navigation context
NavigatorState createMockNavigator() {
  final mockNavigator = MockNavigator();
  when(() => mockNavigator.pushNamed(any())).thenAnswer((_) => Future.value());
  return mockNavigator;
}

/// Test user data
final testUser = User(
  id: 'test123',
  name: 'Test User',
  email: 'test@example.com',
  photoUrl: 'https://example.com/avatar.jpg',
  provider: 'google',
  isActive: true,
  createdAt: DateTime.now(),
);

/// Test event data
final testEvent = Event(
  id: 'event123',
  clubId: 'club456',
  title: 'Test Event',
  description: 'This is a test event',
  startTime: DateTime.now().add(const Duration(days: 1)),
  endTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
  location: 'Test Location',
  category: 'Tech',
  capacity: 10,
  participantIds: ['user1', 'user2'],
  imageUrl: 'https://example.com/event.jpg',
);

/// Extension for WidgetTester with common test operations
extension WidgetTesterExtensions on WidgetTester {
  Future<void> tapButton(String text) async {
    await tap(find.text(text));
    await pump();
  }

  Future<void> enterTextIntoField(String text, {bool obscureText = false}) async {
    final finder = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.obscureText == obscureText,
    );
    await enterText(finder, text);
    await pump();
  }
}