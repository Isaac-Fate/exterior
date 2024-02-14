import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../database_manager.dart';
import './expense.dart';

class ExpenseListController extends GetxController {
  final batchSize = 20;
  final _expenses = <Expense>[].obs;
  DocumentSnapshot? _lastDocument;
  final _databaseManager = Get.find<DatabaseManager>();

  List<Expense> get expenses => _expenses;

  addExpense(Expense expense) async {
    // Add to the database and get the new expense ID
    final expenseId = await _databaseManager.addExpense(expense);

    // Set the ID of the expense
    expense.id = expenseId;

    // Clear the list of expenses
    _expenses.clear();

    // Clear the last document
    _lastDocument = null;

    // Refresh
    await refreshExpenses();
  }

  /// Loads a batch of expenses from the database.
  Future<void> loadExpenses() async {
    // Get the expenses from the database
    final (expenses, lastDocument) = await _databaseManager.getExpenses(
      limit: batchSize,
      lastDocument: _lastDocument,
    );

    // Add to the local list
    _expenses.addAll(expenses);

    // Update the last document
    _lastDocument = lastDocument;
  }

  /// Refreshes the list of expenses
  /// by loading the expenses from the start.
  Future<void> refreshExpenses() async {
    // Get the expenses from the database
    final (expenses, lastDocument) = await _databaseManager.getExpenses(
      limit: batchSize,
      lastDocument: _lastDocument,
    );

    // Clear the list of expenses
    _expenses.clear();

    // Clear the last document
    _lastDocument = null;

    _expenses.addAll(expenses);

    // Update the last document
    _lastDocument = lastDocument;
  }
}
