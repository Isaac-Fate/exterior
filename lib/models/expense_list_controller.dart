import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../database_manager.dart';
import './expense.dart';

class ExpenseListController extends GetxController {
  final batchSize = 20;
  final _expenses = <Expense>[].obs;
  DocumentSnapshot? _lastDocument;
  final _databaseManager = Get.find<DatabaseManager>();

  /// Daily total expenses.
  final _dailyTotal = 0.0.obs;

  /// Monthly total expenses.
  final _monthlyTotal = 0.0.obs;

  List<Expense> get expenses => _expenses;
  double get dailyTotal => _dailyTotal.value;
  double get monthlyTotal => _monthlyTotal.value;

  Future<void> addExpense(Expense expense) async {
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

    // Update the total expenses
    _updateTotalExpenses();
  }

  /// Refreshes the list of expenses
  /// by loading the expenses from the start.
  Future<void> refreshExpenses() async {
    // Get the expenses from the database
    final (expenses, lastDocument) = await _databaseManager.getExpenses(
      limit: batchSize,
      lastDocument: null,
    );

    // Clear the list of expenses
    _expenses.clear();

    // Add to the local list
    _expenses.addAll(expenses);

    // Update the last document
    _lastDocument = lastDocument;

    // Update the total expenses
    _updateTotalExpenses();
  }

  Future<void> deleteExpenseAt(int index) async {
    // The expense to delete
    final expense = _expenses[index];

    // Remove the expense from the list
    expenses.removeAt(index);

    // Delete the expense from the database
    await _databaseManager.deleteExpense(expense.id!);

    // Update the total expenses
    _updateTotalExpenses();
  }

  /// Updates the daily and monthly total expenses.
  void _updateTotalExpenses() {
    _updateDailyTotal();
    _updateMonthlyTotal();
  }

  Future<void> _updateDailyTotal() async {
    // Get the daily total from the database
    final total = await _databaseManager.getDailyTotal();

    // Set the daily total
    _dailyTotal.value = total;
  }

  Future<void> _updateMonthlyTotal() async {
    // Get the monthly total from the database
    final total = await _databaseManager.getMonthlyTotal();

    // Set the monthly total
    _monthlyTotal.value = total;
  }
}
