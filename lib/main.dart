import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/app.dart';
import 'package:pocketa/features/categories/data/models/category_model.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/wallets/data/models/wallet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(TransactionAdapter());
  if (!Hive.isAdapterRegistered(11))
    {Hive.registerAdapter(TransactionTypeAdapter());}
  if (!Hive.isAdapterRegistered(20)) Hive.registerAdapter(WalletModelAdapter());
  if (!Hive.isAdapterRegistered(21))
   { Hive.registerAdapter(WalletTypeDtoAdapter());}
  if (!Hive.isAdapterRegistered(1))
{    Hive.registerAdapter(CategoryModelAdapter());}



  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<WalletModel>('wallets');
  await Hive.openBox<Transaction>('transactions');

  // await Hive.deleteBoxFromDisk('transactions');
  // await Hive.deleteBoxFromDisk('wallets');
  // await Hive.deleteBoxFromDisk('categories');

  runApp(const ProviderScope(child: PocketaApp()));
}
