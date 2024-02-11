import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense {
  String? id;
  final String title;
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
  factory Expense.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return Expense.fromJson(data);
  }

  /// Converts a [Timestamp] to a [DateTime].
  static convertTimestampToDateTime(Timestamp timestamp) =>
      DateTime.parse(timestamp.toDate().toString());

  /// Converts a [DateTime] to a [Timestamp].
  static convertDateTimeToTimestamp(DateTime date) => Timestamp.fromDate(date);
}
