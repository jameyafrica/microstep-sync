import 'package:flutter_test/flutter_test.dart';
import 'package:microstep_sync/models/app_user.dart';

void main() { // entry point
  group('AppUser', () {
    test('creates an instance with all fields set', () {
      const user = AppUser( // arrange: build object we're checking
        uid: 'abc123',
        email: 'test@example.com',
        isAnonymous: false,
        displayName: 'Jamey',
      );

      expect(user.uid, 'abc123'); // assert 
      expect(user.email, 'test@example.com');
      expect(user.isAnonymous, false);
      expect(user.displayName, 'Jamey');
    });

    test('allows email and displayName to be null for guest users', () {
      const guest = AppUser(
        uid: 'guest456',
        isAnonymous: true,
      );

      expect(guest.email, null);
      expect(guest.displayName, null);
    });

    test('two AppUsers with identical fields are equal', () {
      const userA = AppUser(uid: 'abc123', isAnonymous: false);
      const userB = AppUser(uid: 'abc123', isAnonymous: false);

      expect(userA, userB);
    });

    test('two AppUsers with different uids are not equal', () {
      const userA = AppUser(uid: 'abc123', isAnonymous: false);
      const userB = AppUser(uid: 'xyz789', isAnonymous: false);

      expect(userA == userB, false);
    });
  });
}