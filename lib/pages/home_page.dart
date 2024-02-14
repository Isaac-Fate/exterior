import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../database_manager.dart';
import '../widgets/expense_list.dart';
import '../widgets/add_expense_dialog.dart';
import '../models/expense_list_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _expenseListController = Get.put(ExpenseListController());

  /// Database manager.
  final DatabaseManager _databaseManager = Get.find<DatabaseManager>();

  /// Logger.
  final _logger = Get.find<Logger>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: const Text(
                      'Exterior',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                          child: Row(
                            children: [
                              const Text(
                                'User:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _databaseManager.user.displayName ?? '',
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const ExpenseList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          'Daily Total:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        // FirebaseAuth.instance.signOut().then((_) {
                        //   Get.offNamed('/login');
                        // });
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          _showAddExpenseDialog();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddExpenseDialog(
          onExpenseCreated: (expense) {
            try {
              _expenseListController.addExpense(expense);
            } catch (e) {
              _logger.e('Error adding expense: $e');
            }
          },
        );
      },
    );
  }
}
