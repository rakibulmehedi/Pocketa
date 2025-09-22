import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flow/features/transaction/domain/entities/transaction_type.dart';

class GetTransactionsBetweenArgs {
  final DateTime from;
  final DateTime to; // [from, to)
  final String? walletId;
  final String? categoryId;
  final TransactionType? type;
  final bool includeDeleted;
  const GetTransactionsBetweenArgs({
    required this.from,
    required this.to,
    this.walletId,
    this.categoryId,
    this.type,
    this.includeDeleted = false,
  });
}

class GetTransactionsBetween {
  final TransactionRepository repo;
  const GetTransactionsBetween(this.repo);

  List<TransactionEntity> call(GetTransactionsBetweenArgs a) => repo.between(
    a.from,
    a.to,
    walletId: a.walletId,
    categoryId: a.categoryId,
    type: a.type,
    includeDeleted: a.includeDeleted,
  );
}
