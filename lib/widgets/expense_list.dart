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
  /// The list of expenses to display.
  // final List<Expense> expenses;

  final void Function(Expense expense)? deleteExpense;

  const ExpenseList(
      // this.expenses,
      {
    super.key,
    this.deleteExpense,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final _scrollController = ScrollController();
  final _maxNumItemsPerPage = 20;
  DocumentSnapshot? _lastDocument;
  // List<Expense> _expenses = [];

  final _expenseListController = Get.find<ExpenseListController>();
  late final _expenses = _expenseListController.expenses;
  final _logger = Get.find<Logger>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _expenseListController.loadExpensesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: widget.expenses.length,
    //   itemBuilder: (context, index) {
    //     final expense = widget.expenses[index];
    //     if (index == 0 ||
    //         (expense.date.month != widget.expenses[index - 1].date.month ||
    //             expense.date.day != widget.expenses[index - 1].date.day)) {
    //       return Column(
    //         children: [
    //           Row(
    //             children: [
    //               const Text('Date: ',
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 16.0,
    //                   )),
    //               Text(
    //                 DateFormat('yyyy-MM-dd').format(expense.date),
    //               ),
    //             ],
    //           ),
    //           const DashedDivider(),
    //           ExpenseItem(
    //             expense,
    //             onDismissed: () {
    //               _deleteExpenseAt(index);
    //             },
    //           ),
    //         ],
    //       );
    //     }

    //     return ExpenseItem(
    //       widget.expenses[index],
    //       onDismissed: () {
    //         _deleteExpenseAt(index);
    //       },
    //     );
    //   },
    // );

    return Obx(() {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
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
      print('Reached the end of the list. Loading more...');
      _expenseListController.loadExpensesFromFirestore();
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
