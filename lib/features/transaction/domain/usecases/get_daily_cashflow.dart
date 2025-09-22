import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetDailyCashflowArgs {
  final DateTime month;
  final String? walletId;
  final bool includeDeleted;
  const GetDailyCashflowArgs({
    required this.month,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetDailyCashflow {
  final TransactionRepository repo;
  const GetDailyCashflow(this.repo);

  List<Map<String, dynamic>> call(GetDailyCashflowArgs a) => repo.dailyCashflow(
    a.month,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
