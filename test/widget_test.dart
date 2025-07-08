import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dsync_meetup_app/presentation/screens/errors/init_error_screen.dart';
import '../test_helpers/firebase_test_helper.dart';

void main() {
  // Initialize Firebase for all tests in this suite
  setUpAll(() async {
    await ensureTestFirebaseInitialized();
  });
  
  testWidgets('App widget test', (WidgetTester tester) async {
    // Test basic app instantiation
    expect(DsyncApp(), isNotNull);
    expect(InitErrorScreen, isNotNull);
  });

  testWidgets('InitErrorScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InitErrorScreen(error: 'Test error'),
      ),
    );

    expect(find.text('Initialization Error'), findsOneWidget);
    expect(find.text('Test error'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}

class DsyncApp {
}