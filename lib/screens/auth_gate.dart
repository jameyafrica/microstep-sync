import 'package:flutter/material.dart';
import 'package:microstep_sync/models/app_user.dart';
import 'package:microstep_sync/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, this.authService});

  final AuthService? authService;

  @override
  Widget build(BuildContext context) {
    final service = authService ?? AuthService();

    return StreamBuilder<AppUser?>(
      stream: service.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Signed out')),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Signed in')),
        );
      },
    );
  }
}