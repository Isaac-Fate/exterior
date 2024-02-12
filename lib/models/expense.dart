import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense {
  /// The unique identifier of the expense.
  /// This is set when the expense is created from a [DocumentSnapshot].
  /// It is not included when the expense is converted to a JSON object.
  @JsonKey(
    includeToJson: false,
  )
  String? id;

  /// The title of the expense.
  final String title;

  /// The amount of the expense.
  final double amount;

  /// The date of the expense.
  @JsonKey(
    fromJson: convertTimestampToDateTime,
    toJson: convertDateTimeToTimestamp,
  )
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  /// Ccreates an [Expense] from a JSON object.
  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  /// Converts this [Expense] to a JSON object.
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  /// Creates an [Expense] from a [DocumentSnapshot].
  /// The expense id is set to the document id.
  factory Expense.fromDocument(DocumentSnapshot document) {
    // Get the data from the document
    final data = document.data() as Map<String, dynamic>;

    // Parse the data to create the expense
    final expense = Expense.fromJson(data);

    // Set the id of the expense
    expense.id = document.id;

    return expense;
  }

  /// Converts a [Timestamp] to a [DateTime].
  static convertTimestampToDateTime(Timestamp timestamp) =>
      DateTime.parse(timestamp.toDate().toString());

  /// Converts a [DateTime] to a [Timestamp].
  static convertDateTimeToTimestamp(DateTime date) => Timestamp.fromDate(date);
}
