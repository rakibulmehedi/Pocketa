import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/app.dart';
import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/features/categories/data/models/category_model.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/wallets/data/models/wallet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TransactionAdapter());

  Hive.registerAdapter(WalletTypeDtoAdapter()); // enum adapter
  Hive.registerAdapter(WalletModelAdapter());

  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<CategoryModel>('categories');

  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<WalletModel>('wallets');

  runApp(const ProviderScope(child: PocketaApp()));
}
