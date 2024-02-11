import 'package:exterior/models/expense.dart';
import 'package:flutter/material.dart';
import 'custom_theme_text_field.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _titleController = TextEditingController();
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
                  final title = _titleController.text.trim();
                  final amount = double.tryParse(_amountController.text) ?? 0.0;
                  if (title.isNotEmpty && amount > 0) {
                    Navigator.of(context).pop(
                      Expense(
                        title: title,
                        amount: amount,
                      ),
                    );
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
