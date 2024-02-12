import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import './expense.dart';

class ExpenseListController extends GetxController {
  final batchSize = 20;
  final _expenses = <Expense>[].obs;
  DocumentSnapshot? _lastDocument;

  List<Expense> get expenses => _expenses;

  loadExpensesFromFirestore() async {
    Query query = FirebaseFirestore.instance
        .collection('Users')
        .doc('test')
        .collection('Expenses')
        .orderBy('date', descending: true)
        .limit(batchSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    print('length: ${querySnapshot.docs.length}');
    if (querySnapshot.docs.isEmpty) {
      print('No more expenses to load');
      return;
    }

    _lastDocument = querySnapshot.docs.last;

    _expenses.addAll(querySnapshot.docs.map(Expense.fromDocument));
  }
}
