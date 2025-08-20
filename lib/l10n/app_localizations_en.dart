// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pocketa';

  @override
  String get welcome => 'Welcome';

  @override
  String get language_en => 'English';

  @override
  String get language_bn => 'Bangla';

  @override
  String get switchLanguage => 'Switch language';

  @override
  String homeGreeting(Object name) {
    return 'Hi, $name!';
  }
}
