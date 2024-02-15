import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((User? user) async {
      // Delay for a little bit to show the splash screen
      await Future.delayed(const Duration(seconds: 1));

      if (user == null) {
        // Navigate to the login page if the user is not logged in
        Get.offAndToNamed('/login');
      } else {
        // Set up a database manager
        final databaseManager = DatabaseManager(user: user);

        // Put the database manager into the GetX dependency manager
        Get.put(databaseManager);

        // Navigate to the home page if the user is logged in
        Get.offAndToNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                // The logo image
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset(
                    'assets/icons/exterior.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // The loading indicator
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
