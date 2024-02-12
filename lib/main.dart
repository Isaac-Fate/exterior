import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import './pages/home_page.dart';

void main() async {
  // Ensure the widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase app
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Exterior',
      theme: ThemeData(
        primaryColor: Colors.black,
        focusColor: Colors.grey,
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          shadowColor: Colors.grey,
        ),
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
      initialBinding: BindingsBuilder(() {
        Get.put(Logger(
          printer: PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 3,
          ),
        ));
      }),
    );
  }
}
