import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/domain/repositories/transaction_repository.dart';

class GetMonthSummary {
  final TransactionRepository repository;
  const GetMonthSummary(this.repository);

  double income(int year, int month, {String? walletId}) =>
      repository.totalAmountByType(
        TransactionType.income,
        year,
        month,
        walletId: walletId,
      );
  double expense(int year, int month, {String? walletId}) =>
      repository.totalAmountByType(
        TransactionType.expense,
        year,
        month,
        walletId: walletId,
      );
  double net(int year, int month, {String? walletId}) =>
      repository.netForMonth(year, month, walletId: walletId);
}
