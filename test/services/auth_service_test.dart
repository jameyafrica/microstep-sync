import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:microstep_sync/services/auth_service.dart';
import 'package:microstep_sync/models/app_user.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
  });

  setUpAll(() {
    registerFallbackValue(
      EmailAuthProvider.credential(email: 'fallback@example.com', password: 'fallback'),
    );
  });

  group('signInAnonymously', () {
    test('calls FirebaseAuth.signInAnonymously() and completes normally', () async {
      when(() => mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => MockUserCredential());

      await authService.signInAnonymously();

      verify(() => mockFirebaseAuth.signInAnonymously()).called(1);
    });

    test('throws AuthException when FirebaseAuthException is thrown', () async {
      when(() => mockFirebaseAuth.signInAnonymously()).thenThrow(
        FirebaseAuthException(code: 'network-request-failed', message: 'No internet.'),
      );

      expect(
        () => authService.signInAnonymously(),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('signUpWithEmail', () {
    test('calls createUserWithEmailAndPassword with correct args', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => MockUserCredential());

      await authService.signUpWithEmail('test@example.com', 'password123');

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('throws AuthException when FirebaseAuthException is thrown', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(
        FirebaseAuthException(code: 'weak-password', message: 'Password too weak.'),
      );

      expect(
        () => authService.signUpWithEmail('test@example.com', '123'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('signInWithEmail', () {
    test('calls signInWithEmailAndPassword with correct args', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => MockUserCredential());

      await authService.signInWithEmail('test@example.com', 'password123');

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('throws AuthException when FirebaseAuthException is thrown', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(
        FirebaseAuthException(code: 'wrong-password', message: 'Incorrect password.'),
      );

      expect(
        () => authService.signInWithEmail('test@example.com', 'wrongpass'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('signOut', () {
    test('calls FirebaseAuth.signOut() and completes normally', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await authService.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('throws AuthException when FirebaseAuthException is thrown', () async {
      when(() => mockFirebaseAuth.signOut()).thenThrow(
        FirebaseAuthException(code: 'network-request-failed', message: 'No internet.'),
      );

      expect(
        () => authService.signOut(),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('authStateChanges', () {
    test('maps a non-null User into an AppUser', () async {
      final mockUser = MockUser();
      when(() => mockUser.uid).thenReturn('abc123');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.isAnonymous).thenReturn(false);
      when(() => mockUser.displayName).thenReturn('Test User');

      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      final result = await authService.authStateChanges.first;

      expect(result, isA<AppUser>());
      expect(result?.uid, 'abc123');
      expect(result?.email, 'test@example.com');
      expect(result?.isAnonymous, false);
      expect(result?.displayName, 'Test User');
    });

    test('maps a null User into null', () async {
      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      final result = await authService.authStateChanges.first;

      expect(result, isNull);
    });
  });

    group('linkAnonymousWithEmail', () {
    test('calls linkWithCredential on the current user with correct credential', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.linkWithCredential(any()))
          .thenAnswer((_) async => MockUserCredential());

      await authService.linkAnonymousWithEmail('test@example.com', 'password123');

      verify(() => mockUser.linkWithCredential(any())).called(1);
    });

    test('throws AuthException when there is no current user', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(
        () => authService.linkAnonymousWithEmail('test@example.com', 'password123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws AuthException when FirebaseAuthException is thrown', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.linkWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'weak-password', message: 'Password too weak.'),
      );

      expect(
        () => authService.linkAnonymousWithEmail('test@example.com', 'weak'),
        throwsA(isA<AuthException>()),
      );
    });

    test('throws AuthException with code "credential-already-in-use" on conflict', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.linkWithCredential(any())).thenThrow(
        FirebaseAuthException(
          code: 'credential-already-in-use',
          message: 'This email is already linked to another account.',
        ),
      );

      try {
        await authService.linkAnonymousWithEmail('taken@example.com', 'password123');
        fail('Expected an AuthException to be thrown');
      } on AuthException catch (e) {
        expect(e.code, 'credential-already-in-use');
      }
    });
  });

}