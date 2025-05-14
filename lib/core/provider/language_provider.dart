// lib/core/provider/language_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { bangla, english }

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.english);
