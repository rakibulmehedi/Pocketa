import 'package:json_annotation/json_annotation.dart';
import 'package:flow/features/transaction/domain/entities/transaction_type.dart';

/// JSON converter for TransactionType enum
class TransactionTypeConverter implements JsonConverter<TransactionType, String> {
  const TransactionTypeConverter();

  @override
  TransactionType fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense; // Default fallback
    }
  }

  @override
  String toJson(TransactionType object) {
    switch (object) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
      case TransactionType.transfer:
        return 'transfer';
    }
  }
}
