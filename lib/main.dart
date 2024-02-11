import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './pages/home_page.dart';

void main() {
  // Ensure the widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase app
  Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exterior',
      theme: ThemeData(
        primaryColor: Colors.black,
        focusColor: Colors.grey,
        // dialogTheme: const DialogTheme(
        //   backgroundColor: Colors.white,

        //   shadowColor: Colors.grey,
        // ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}
