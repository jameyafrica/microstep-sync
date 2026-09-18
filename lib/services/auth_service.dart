import 'package:firebase_auth/firebase_auth.dart';
import 'package:microstep_sync/models/app_user.dart';


class AuthException implements Exception {
  final String message;
  final String? code;
  AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class AuthService {
 final FirebaseAuth _firebaseAuth;

AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance; // class from the firebase package, their own auth object (the thing that knows how to talk to Google)
                                    //(singleton)
  Future<void> signInAnonymously() async {
  try {
    await _firebaseAuth.signInAnonymously();
  } on FirebaseAuthException catch (e) {
   throw AuthException(e.message ?? 'Anonymous sign-in failed.', code: e.code);
  }
  }

  Future<void> signUpWithEmail(String email, String password) async {
   try {
     await _firebaseAuth.createUserWithEmailAndPassword(  //firebases method for account creation 
      email: email,
      password: password,
    );
   } on FirebaseAuthException catch (e) {
    throw AuthException(e.message ?? 'Sign up failed', code: e.code);
   }
  }


  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign in failed', code: e.code);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Sign out failed', code: e.code);
    }
  
}

Future<void> linkAnonymousWithEmail(String email, String password) async {
  final currentUser = _firebaseAuth.currentUser;
  if (currentUser == null) {
    throw AuthException('No signed-in user to link.');
  }

  final credential = EmailAuthProvider.credential(
    email: email,
    password: password,
  );

  try {
    await currentUser.linkWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    throw AuthException(e.message ?? 'Account linking failed.', code: e.code);
  }
}

//written as a getter, not methid with()
// map -> everytime a new val come in, runs through the function and emits that instead
Stream<AppUser?> get authStateChanges {
  return _firebaseAuth.authStateChanges().map((User? firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      isAnonymous: firebaseUser.isAnonymous,
      displayName: firebaseUser.displayName,
    );
  });
}

}