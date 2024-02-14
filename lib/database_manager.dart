import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import './models/expense.dart';

class DatabaseManager {
  /// The current user.
  User user;

  /// Name of the collection of users.
  static const String userCollectionName = 'Users';

  /// Name of the collection of expenses of each user.
  static const String expenseCollectionName = 'Expenses';

  ///  Firestore instance.
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reference to the collection of users.
  static final CollectionReference userCollection =
      _db.collection(userCollectionName);

  /// Logger.
  final Logger _logger = Get.find<Logger>();

  DatabaseManager({
    required this.user,
  });

  /// Gets the user's expenses collection.
  CollectionReference get expenseCollection =>
      userCollection.doc(user.uid).collection(expenseCollectionName);

  /// Adds a new expense to the user's expenses collection.
  /// The input [expense] is without the ID.
  /// Returns the document ID of the newly added expense.
  Future<String> addExpense(Expense expense) async {
    print('user: ${user.uid}');
    // Get the newly added document
    final document = await expenseCollection.add(expense.toJson());

    // Log
    _logger.i('Expense with ID ${document.id} is added');

    // Return the document ID
    return document.id;
  }

  /// Gets the user's expenses from the expenses collection.
  /// The [limit] parameter is the number of expenses to get.
  /// The [lastDocument] parameter is the last document to start after.
  /// Returns a list of expenses and the last document.
  Future<
      (
        List<Expense>,
        DocumentSnapshot?,
      )> getExpenses({
    int? limit,
    DocumentSnapshot? lastDocument,
  }) async {
    // The query
    Query query = expenseCollection.orderBy('date', descending: true);

    // If the limit is not null, set the limit
    if (limit != null) {
      query = query.limit(limit);
    }

    // If the last document is not null, set the start after document
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    // Get the query snapshot
    final querySnapshot = await query.get();

    // Log
    _logger.i('Loaded ${querySnapshot.docs.length} expenses');

    // If the query snapshot is empty, return an empty list
    if (querySnapshot.docs.isEmpty) {
      return (<Expense>[], null);
    }

    // Convert to the list of expenses
    final expenses = querySnapshot.docs.map(Expense.fromDocument).toList();

    // The new last document
    final newLastDocument = querySnapshot.docs.last;

    return (expenses, newLastDocument);
  }

  /// Deletes an expense from the user's expenses collection.
  Future<void> deleteExpense(String expenseId) async {
    // Delete the expense
    await expenseCollection.doc(expenseId).delete();

    // Log
    _logger.i('Expense with ID $expenseId is deleted');
  }
}
