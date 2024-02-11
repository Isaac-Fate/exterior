import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import './expense_item.dart';
import './dashed_divider.dart';

class ExpenseList extends StatefulWidget {
  /// The list of expenses to display.
  final List<Expense> expenses;

  final void Function(Expense expense)? deleteExpense;

  const ExpenseList(
    this.expenses, {
    super.key,
    this.deleteExpense,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final ScrollController _scrollController = ScrollController();
  final _maxNumItemsPerPage = 10;
  DocumentSnapshot? _lastDocument;
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _loadExpenses();
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

    return ListView.builder(
      controller: _scrollController,
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return ExpenseItem(
          expense,
        );
      },
    );
  }

  _loadExpenses() async {
    Query query = FirebaseFirestore.instance
        .collection('Users')
        .doc('test')
        .collection('Expenses')
        .orderBy('date')
        .limit(_maxNumItemsPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.length < _maxNumItemsPerPage) {
      _scrollController.removeListener(_scrollListener);
    }

    _lastDocument = querySnapshot.docs.last;

    setState(() {
      _expenses.addAll(querySnapshot.docs.map(Expense.fromDocument).toList());
    });
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadExpenses();
    }
  }

  _deleteExpenseAt(int index) {
    // The expense to delete
    final expense = widget.expenses[index];

    setState(() {
      widget.expenses.removeAt(index);
      widget.deleteExpense?.call(expense);
    });
  }
}
