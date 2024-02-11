import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_list.dart';
import '../widgets/add_expense_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> expenses = [
    Expense(title: 'Groceries', amount: 50.0, date: DateTime.now()),
    Expense(title: 'Rent', amount: 500.0, date: DateTime.now()),
    // Expense(title: 'Rent', amount: 500.0, date: DateTime.now()),
    Expense(
        title: 'Utilities',
        amount: 150.0,
        date: DateTime.now().subtract(Duration(days: 1))),
    // Add more mock expenses as needed
  ];

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
            Expanded(
              child: ExpenseList(expenses),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AddExpenseDialog();
      },
    );
  }
}
