import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flow/core/db/hive_box.dart';
import 'package:flow/core/db/hive_helpers.dart';

// Import all models/enums once here
import 'package:flow/features/categories/data/models/category_model.dart';
import 'package:flow/features/transaction/data/models/transaction_model.dart';
import 'package:flow/features/wallets/data/models/wallet_model.dart';

Future<void> hiveBootstrap() async {
  await Hive.initFlutter('pocketa_db');
  Hive
    ..registerAdapter(TransactionAdapter())
    ..registerAdapter(WalletModelAdapter())
    ..registerAdapter(WalletTypeDtoAdapter())
    ..registerAdapter(CategoryModelAdapter());

  await _safeOpen<Transaction>(HiveBoxes.transactions);
  await _safeOpen<WalletModel>(HiveBoxes.wallets);
  await _safeOpen<CategoryModel>(HiveBoxes.categories);
  await _safeOpen<dynamic>(HiveBoxes.prefs);
  final txBox = Hive.box<Transaction>(HiveBoxes.transactions);
  if (shouldCompact(txBox.length, threshold: 2000)) {
    await _compactIfNeeded(txBox, threshold: 2000);
  }

  debugPrint(
      'Transactions box open: ${Hive.isBoxOpen(HiveBoxes.transactions)}');
}

/// Safe open with basic corruption recovery (delete and reopen if needed).
Future<Box<T>> _safeOpen<T>(String name) async {
  try {
    return await Hive.openBox<T>(name);
  } on HiveError catch (e) {
    // Unknown type or corrupted box
    final msg = e.toString().toLowerCase();
    if (msg.contains('unknown typeid') || msg.contains('corrupt')) {
      debugPrint('Hive box "$name" corrupted or incompatible. Recreating...');
      await Hive.deleteBoxFromDisk(name);
      return await Hive.openBox<T>(name);
    }
    rethrow;
  }
}

Future<void> _compactIfNeeded<T>(Box<T> box, {int threshold = 1000}) async {
  // If lots of ops expected, compact to keep file small.
  if (box.length >= threshold) {
    try {
      await box.compact();
    } catch (_) {
      // ignore compaction errors silently
    }
  }
}
