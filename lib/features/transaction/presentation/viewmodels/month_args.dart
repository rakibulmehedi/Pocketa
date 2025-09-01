import 'package:equatable/equatable.dart';

/// Light, hashable args for Provider.family
class MonthArgs extends Equatable {
  final int y;
  final int m;
  final String? walletId;

  const MonthArgs({required this.y, required this.m, this.walletId});

  /// Build args for the month of [d] (UTC or local fine) and optional wallet.
  factory MonthArgs.of(DateTime d, {String? walletId}) =>
      MonthArgs(y: d.year, m: d.month, walletId: walletId);

  @override
  List<Object?> get props => [y, m, walletId];
}
