class AppUser {
  final String uid; 
  final String? email;
  final bool isAnonymous;
  final String? displayName;

  const AppUser({
    required this.uid,
    this.email,
    required this.isAnonymous,
    this.displayName,
  });

  //overriding tells dart that if 2 objects are equal they must also produce the same hash code 
  @override
  bool operator ==(Object other) {
    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.isAnonymous == isAnonymous &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(uid, email, isAnonymous, displayName);

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, isAnonymous: $isAnonymous, displayName: $displayName)';
  }
}