import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:microstep_sync/screens/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  //wires up before any async work is done -> sets up flutters messaging channels early
  WidgetsFlutterBinding.ensureInitialized();
  //this functions needs to run and complete before any other firebase call (sign in etc)
  await Firebase.initializeApp(
    //actual connection call
    //heler functuion that automatically picks the correct config -> depending on platform (android or web)
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); //boots and attaches widgets to the screen
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroStep Sync',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
    );
  }
}