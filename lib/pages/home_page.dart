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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SafeArea(
              child: Text(
                'Exterior',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
            const Expanded(
              child: ExpenseList(),
            ),
            const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                child: Column(
                  children: [
                    // Daily total
                    Row(
                      children: [
                        const Text(
                          'Daily Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _expenseListController.dailyTotal.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),

                    // Monthly total
                    Row(
                      children: [
                        const Text(
                          'Monthly Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _expenseListController.monthlyTotal
                              .toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
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
          onExpenseCreated: (expense) async {
            try {
              // Use the expense list controller to add the expense
              await _expenseListController.addExpense(expense);

              // Update the monthly total
            } catch (e) {
              _logger.e('Error adding expense: $e');
            }
          },
        );
      },
    );
  }
}
