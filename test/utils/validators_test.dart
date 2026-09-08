import 'package:flutter_test/flutter_test.dart';
import 'package:microstep_sync/utils/validator.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('accepts a normal, well-formed email', () {
      expect(Validators.isValidEmail('test@example.com'), true);
    });

    test('rejects a string with no @ symbol', () {
      expect(Validators.isValidEmail('testexample.com'), false);
    });

    test('rejects a string with no domain extension', () {
      expect(Validators.isValidEmail('test@example'), false);
    });

    test('rejects an empty string', () {
      expect(Validators.isValidEmail(''), false);
    });

    test('rejects valid-looking email with trailing garbage', () {
      expect(Validators.isValidEmail('test@example.com<script>'), false);
    });
  });

  group('Validators.isStrongPassword', () {
    test('accepts a password of exactly 8 characters', () {
      expect(Validators.isStrongPassword('abcd1234'), true);
    });

    test('accepts a password longer than 8 characters', () {
      expect(Validators.isStrongPassword('abcd12345678'), true);
    });

    test('rejects a password of exactly 7 characters', () {
      expect(Validators.isStrongPassword('abcd123'), false);
    });

    test('rejects an empty string', () {
      expect(Validators.isStrongPassword(''), false);
    });
  });
}