/// Transaction type enumeration
enum TransactionType {
  income,
  expense,
  transfer,
}

/// Extension methods for TransactionType
extension TransactionTypeExtension on TransactionType {
  /// Get display name for the transaction type
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }
  
  /// Check if this is an income transaction
  bool get isIncome => this == TransactionType.income;
  
  /// Check if this is an expense transaction
  bool get isExpense => this == TransactionType.expense;
  
  /// Check if this is a transfer transaction
  bool get isTransfer => this == TransactionType.transfer;
}