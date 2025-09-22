import 'package:flow/features/transaction/domain/repositories/transaction_repository.dart';

class GetMonthlyNetSeriesArgs {
  final int monthsBack;
  final String? walletId;
  final bool includeDeleted;
  const GetMonthlyNetSeriesArgs({
    required this.monthsBack,
    this.walletId,
    this.includeDeleted = false,
  });
}

class GetMonthlyNetSeries {
  final TransactionRepository repo;
  const GetMonthlyNetSeries(this.repo);

  List<double> call(GetMonthlyNetSeriesArgs a) => repo.monthlyNetSeries(
    a.monthsBack,
    walletId: a.walletId,
    includeDeleted: a.includeDeleted,
  );
}
