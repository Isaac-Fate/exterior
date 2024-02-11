// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: Expense.convertTimestampToDateTime(json['date'] as Timestamp),
    )..id = json['id'] as String?;

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'date': Expense.convertDateTimeToTimestamp(instance.date),
    };
