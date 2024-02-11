import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  // final Function? onItemDismissed;
  final Expense expense;
  final VoidCallback? onDismissed;

  const ExpenseItem(
    this.expense, {
    super.key,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.date.toString()),
      background: Container(
        color: Colors.grey,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20.0,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
          ),
        ),
        trailing: Text(expense.amount.toStringAsFixed(2),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            )),
      ),
      onDismissed: (direction) {
        onDismissed?.call();
      },
    );
  }
}
