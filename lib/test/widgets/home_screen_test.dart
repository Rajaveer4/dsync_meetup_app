import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dsync_meetup_app/presentation/screens/home/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart'; // Added import
import 'package:dsync_meetup_app/presentation/routes/app_router.dart';

class MockGoRouter extends Mock implements GoRouter {}
class MockAuthCubit extends Mock implements AuthCubit {} // Added mock

void main() {
  late MockGoRouter mockRouter;
  late MockAuthCubit mockAuthCubit; // Changed to mock

  setUp(() {
    mockRouter = MockGoRouter();
    mockAuthCubit = MockAuthCubit();
    when(() => mockRouter.push(any())).thenAnswer((_) async => null);
    when(() => mockRouter.go(any())).thenAnswer((_) async {});
  });

  testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );
    
    expect(find.text('Welcome to DSync Meetup'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('HomeScreen navigation to clubs works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: AppRouter(mockAuthCubit).router,
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );

    // First navigate to home screen
    await tester.pumpAndSettle();
    
    // Then test navigation
    await tester.tap(find.text('Clubs'));
    await tester.pumpAndSettle();
    
    // Verify navigation occurred
    verify(() => mockRouter.go('/clubs')).called(1);
  });

  testWidgets('HomeScreen displays user profile', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
    
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Welcome back,'), findsOneWidget);
  });
}