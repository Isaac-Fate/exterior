import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  /// Expense controller.
  final _expenseListController = Get.find<ExpenseListController>();

  /// Scroll controller used in ListView.
  final _scrollController = ScrollController();

  /// Logger.
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
      // Wrap with a MediaQuery to
      // remove the whitesapce above the first item
      // in the list view
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,

        // The list view of user's expenses
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _expenseListController.expenses.length,
          itemBuilder: (context, index) {
            final expense = _expenseListController.expenses[index];
            if (index == 0 ||
                (expense.date.month !=
                        _expenseListController.expenses[index - 1].date.month ||
                    expense.date.day !=
                        _expenseListController.expenses[index - 1].date.day)) {
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
                      _expenseListController.deleteExpenseAt(index);
                    },
                  ),
                ],
              );
            }
            return ExpenseItem(
              expense,
              onDismissed: () {
                _expenseListController.deleteExpenseAt(index);
              },
            );
          },
        ),
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
}
