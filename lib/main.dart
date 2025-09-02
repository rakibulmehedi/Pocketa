import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/app.dart';
import 'package:pocketa/core/db/hive_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveBootstrap();
  runApp(const ProviderScope(child: PocketaApp()));
}
