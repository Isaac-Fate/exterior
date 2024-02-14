import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/expense.dart';
import './expense_item.dart';
import './dashed_divider.dart';
import '../models/expense_list_controller.dart';

class ExpenseList extends StatefulWidget {
  final void Function(Expense expense)? deleteExpense;

  const ExpenseList({
    super.key,
    this.deleteExpense,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final _scrollController = ScrollController();

  final _expenseListController = Get.find<ExpenseListController>();
  late final _expenses = _expenseListController.expenses;
  final _logger = Get.find<Logger>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _expenseListController.loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          if (index == 0 ||
              (expense.date.month != _expenses[index - 1].date.month ||
                  expense.date.day != _expenses[index - 1].date.day)) {
            return Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                      child: Text('Date: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          )),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(expense.date),
                    ),
                  ],
                ),
                const DashedDivider(),
                ExpenseItem(
                  expense,
                  onDismissed: () {
                    _deleteExpenseAt(index);
                  },
                ),
              ],
            );
          }
          return ExpenseItem(
            expense,
            onDismissed: () {
              _deleteExpenseAt(index);
            },
          );
        },
      );
    });
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _logger.i('Reached the end of the list. Loading more...');
      _expenseListController.loadExpenses();
    }
  }

  _deleteExpenseAt(int index) {
    // The expense to delete
    final expense = _expenses[index];

    // Remove the expense from the list
    setState(() {
      _expenses.removeAt(index);
    });

    // Delete the expense from the database
    FirebaseFirestore.instance
        .collection('Users')
        .doc('test')
        .collection('Expenses')
        .doc(expense.id)
        .delete()
        .then((doc) => _logger.i('Expense with ID ${expense.id} is deleted'))
        .onError((error, stackTrace) {
      // Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete the expense: $error'),
        ),
      );
    });
  }
}
