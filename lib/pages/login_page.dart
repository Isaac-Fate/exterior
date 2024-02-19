import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../database_manager.dart';
import '../widgets/custom_theme_text_field.dart';

enum LoginPageMode {
  login,
  register,
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// The current mode of the login page.
  LoginPageMode _mode = LoginPageMode.login;

  /// Whether the page is loading when the user is logging in or registering.
  bool _isLoading = false;

  /// Firebase authentication instance.
  final _auth = FirebaseAuth.instance;

  /// Controller for the username text field.
  final _usernameController = TextEditingController();

  /// Controller for the email text field.
  final _emailController = TextEditingController();

  /// Controller for the password text field.
  final _passwordController = TextEditingController();

  /// Logger.
  final _logger = Get.find<Logger>();

  @override
  Widget build(BuildContext context) {
    late final Widget form;
    switch (_mode) {
      case LoginPageMode.login:
        form = _buildLoginForm();
        break;
      case LoginPageMode.register:
        form = _buildRegisterForm();
        break;
    }

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

                // Login or register form
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: form,
                ),
              ],
            ),

            // Loading indicator
            if (_isLoading) ...[
              ModalBarrier(
                dismissible: false,
                color: Colors.grey.withOpacity(0.3),
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Text fields
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5 * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomThemeTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                CustomThemeTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),

        // Login button and register link
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5 * 0.4,
          child: Column(
            children: [
              // Login button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    )),
                child: const Text('Login'),
              ),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _mode = LoginPageMode.register;
                      });
                    },
                    child: const Text(
                      'Register one',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Text fields
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5 * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomThemeTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                ),
                CustomThemeTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                CustomThemeTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),

        // Register button and login link
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5 * 0.4,
          child: Column(
            children: [
              // Register button
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    )),
                child: const Text('Register'),
              ),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _mode = LoginPageMode.login;
                      });
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _login() async {
    try {
      // Loading
      setState(() {
        _isLoading = true;
      });

      // Email
      final email = _emailController.text.trim();

      // Password
      final password = _passwordController.text;

      // Sign in with email and password
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Complete loading
      setState(() {
        _isLoading = false;
      });

      // Get the user
      final user = userCredential.user;

      // If the user is not null,
      // which means the user is successfully authenticated
      // Navigate to the home page
      if (user != null) {
        // Set up database manager
        final databaseManager = DatabaseManager(user: user);

        // Put the database manager into the GetX dependency injection system
        Get.put(databaseManager);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Show a snackbar
        Get.showSnackbar(
          const GetSnackBar(
            message: 'No user found for that email',
            duration: Duration(seconds: 1),
          ),
        );

        // Log
        _logger.e('No user found for that email');
      } else if (e.code == 'wrong-password') {
        // Show a snackbar
        Get.showSnackbar(
          const GetSnackBar(
            message: 'Wrong password provided for that user',
            duration: Duration(seconds: 1),
          ),
        );

        // Log
        _logger.e('Wrong password provided for that user');
      }
    } catch (e) {
      // Show a snackbar
      Get.showSnackbar(
        const GetSnackBar(
          message: 'An error occurred',
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  _register() async {
    try {
      // Email
      final email = _emailController.text.trim();

      // Password
      final password = _passwordController.text;

      // Username
      final username = _usernameController.text.trim();

      // Register a new user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // The user object
      final user = userCredential.user;

      if (user != null) {
        // Set the user's name
        await user.updateDisplayName(username);

        // Set up database manager
        final databaseManager = DatabaseManager(user: user);

        // Put the database manager into the GetX dependency injection system
        Get.put(databaseManager);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // Show a snackbar
        Get.showSnackbar(
          const GetSnackBar(
            message: 'The password provided is too weak',
            duration: Duration(seconds: 1),
            margin: EdgeInsets.all(16.0),
            borderRadius: 16.0,
          ),
        );

        // Log
        _logger.e('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        // Show a snackbar
        Get.showSnackbar(
          const GetSnackBar(
            message: 'The account already exists for that email',
            duration: Duration(seconds: 1),
            snackPosition: SnackPosition.TOP,
          ),
        );

        // Log
        _logger.e('The account already exists for that email');
      }
    } catch (e) {
      // Show a snackbar
      Get.showSnackbar(
        const GetSnackBar(
          message: 'An error occurred',
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
