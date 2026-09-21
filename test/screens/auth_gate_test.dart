import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:microstep_sync/models/app_user.dart';
import 'package:microstep_sync/screens/auth_gate.dart';
import 'package:microstep_sync/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;
  late StreamController<AppUser?> authController;

  setUp(() {
    mockAuthService = MockAuthService();
    authController = StreamController<AppUser?>();
    when(() => mockAuthService.authStateChanges)
        .thenAnswer((_) => authController.stream);
  });

  tearDown(() {
    authController.close();
  });

  testWidgets('shows a loading indicator while the auth stream is pending',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthGate(authService: mockAuthService)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Signed out'), findsNothing);
    expect(find.text('Signed in'), findsNothing);
  });


  testWidgets('shows the signed-out placeholder when the stream emits null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthGate(authService: mockAuthService)),
    );

    authController.add(null);
    await tester.pump();

    expect(find.text('Signed out'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Signed in'), findsNothing);
  });


  testWidgets('shows the signed-in placeholder when the stream emits a user',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthGate(authService: mockAuthService)),
    );

    authController.add(const AppUser(uid: 'test-uid', isAnonymous: true));
    await tester.pump();

    expect(find.text('Signed in'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Signed out'), findsNothing);
  });


    testWidgets('re-renders when the stream emits new values over time',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthGate(authService: mockAuthService)),
    );

    // Emission 1: nobody is signed in.
    authController.add(null);
    await tester.idle();
    await tester.pump();
    expect(find.text('Signed out'), findsOneWidget);
    expect(find.text('Signed in'), findsNothing);

    // Emission 2: the user signs in.
    authController.add(const AppUser(uid: 'test-uid', isAnonymous: true));
    await tester.idle();
    await tester.pump();
    expect(find.text('Signed in'), findsOneWidget);
    expect(find.text('Signed out'), findsNothing);

    // Emission 3: the user signs out again.
    authController.add(null);
    await tester.idle();
    await tester.pump();
    expect(find.text('Signed out'), findsOneWidget);
    expect(find.text('Signed in'), findsNothing);
  });
}