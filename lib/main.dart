import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/app.dart';
import 'package:pocketa/core/db/hive_bootstrap.dart';
import 'package:pocketa/shared/services/celebration_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveBootstrap();
  await CelebrationService.initialize();
  runApp(const ProviderScope(child: PocketaApp()));
}
