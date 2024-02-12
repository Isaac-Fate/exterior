import 'package:exterior/models/expense.dart';
import 'package:flutter/material.dart';
import 'custom_theme_text_field.dart';

class AddExpenseDialog extends StatefulWidget {
  /// Callback function to be called when an expense is created.
  final dynamic Function(Expense expense)? onExpenseCreated;

  const AddExpenseDialog({
    super.key,
    this.onExpenseCreated,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  /// Controller for the title text field.
  final _titleController = TextEditingController();

  /// Controller for the amount text field.
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomThemeTextField(
            controller: _titleController,
            labelText: 'Title',
          ),
          CustomThemeTextField(
            controller: _amountController,
            labelText: 'Amount',
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  // Title without leading or trailing spaces
                  final title = _titleController.text.trim();

                  // The input amount
                  // If the input is not a number, default to 0.0
                  final amount = double.tryParse(_amountController.text) ?? 0.0;

                  if (title.isEmpty) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Title cannot be empty'),
                      ),
                    );
                  } else if (amount <= 0) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Amount must be greater than 0'),
                      ),
                    );
                  } else {
                    // Both title and amount fields are valid
                    // Create the expense
                    final expense = Expense(
                      title: title,
                      amount: amount,
                    );

                    // Call the callback function
                    widget.onExpenseCreated?.call(expense);

                    // Naviagte back to the previous page
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
