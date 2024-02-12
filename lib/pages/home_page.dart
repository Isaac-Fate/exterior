import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/expense.dart';
import '../widgets/expense_list.dart';
import '../widgets/add_expense_dialog.dart';
import '../models/expense_list_controller.dart';

final db = FirebaseFirestore.instance;
final expenseCollection =
    db.collection('Users').doc('test').collection('Expenses');
final dummyExpenses = [
  Expense(title: 'A', amount: 10.0, date: DateTime.now()),
  Expense(title: 'B', amount: 20.0, date: DateTime.now()),
  Expense(title: 'C', amount: 30.0, date: DateTime.now()),
  Expense(title: 'D', amount: 40.0, date: DateTime.now()),
  Expense(title: 'E', amount: 50.0, date: DateTime.now()),
  Expense(title: 'F', amount: 60.0, date: DateTime.now()),
  Expense(title: 'G', amount: 70.0, date: DateTime.now()),
  Expense(title: 'H', amount: 80.0, date: DateTime.now()),
  Expense(title: 'I', amount: 90.0, date: DateTime.now()),
  Expense(title: 'J', amount: 100.0, date: DateTime.now()),
  Expense(title: 'K', amount: 110.0, date: DateTime.now()),
  Expense(title: 'L', amount: 120.0, date: DateTime.now()),
  Expense(title: 'M', amount: 130.0, date: DateTime.now()),
  Expense(title: 'N', amount: 140.0, date: DateTime.now()),
  Expense(title: 'O', amount: 150.0, date: DateTime.now()),
  Expense(title: 'P', amount: 160.0, date: DateTime.now()),
  Expense(title: 'Q', amount: 170.0, date: DateTime.now()),
  Expense(title: 'R', amount: 180.0, date: DateTime.now()),
  Expense(title: 'S', amount: 190.0, date: DateTime.now()),
  Expense(title: 'T', amount: 200.0, date: DateTime.now()),
  Expense(title: 'U', amount: 210.0, date: DateTime.now()),
  Expense(title: 'V', amount: 220.0, date: DateTime.now()),
  Expense(title: 'W', amount: 230.0, date: DateTime.now()),
  Expense(title: 'X', amount: 240.0, date: DateTime.now()),
  Expense(title: 'Y', amount: 250.0, date: DateTime.now()),
  Expense(title: 'Z', amount: 260.0, date: DateTime.now()),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _expenseListController = Get.put(ExpenseListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exterior'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          _showAddExpenseDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         for (final expense in dummyExpenses) {
            //           expenseCollection.add(expense.toJson());
            //         }
            //       },
            //       child: const Text('Add'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         expenseCollection.get().then((snapshot) {
            //           for (final doc in snapshot.docs) {
            //             doc.reference.delete();
            //           }
            //         });
            //       },
            //       child: const Text('Perge'),
            //     ),
            //   ],
            // ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text('User: test'),
                  Divider(),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: ExpenseList(),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Divider(),
                  Text('Daily Total: 0.00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExpense(int index) {
    setState(() {
      // expenses.removeAt(index);
    });
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddExpenseDialog(
          onExpenseCreated: (expense) {
            expenseCollection.add(expense.toJson()).then((doc) {
              expense.id = doc.id;

              _expenseListController.expenses.insert(0, expense);
              print('expenses: ${_expenseListController.expenses}');
            }).onError((error, stackTrace) {
              print('Failed to add expense: $error');
            });
          },
        );
      },
    );
  }
}
