import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tripedia/firebase_options.dart';
import 'package:tripedia/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // menggunakan opsi sesuai platform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripedia',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
