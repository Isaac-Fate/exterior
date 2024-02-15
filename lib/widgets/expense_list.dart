import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../database_manager.dart';
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

  /// Database manager.
  final _databaseManager = Get.find<DatabaseManager>();

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(expense.date),
                      ),
                    ],
                  ),
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
    _databaseManager.deleteExpense(expense.id!);
  }
}
