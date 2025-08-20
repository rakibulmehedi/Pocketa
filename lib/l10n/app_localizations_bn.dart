// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'পকেটা';

  @override
  String get welcome => 'স্বাগতম';

  @override
  String get language_en => 'ইংরেজি';

  @override
  String get language_bn => 'বাংলা';

  @override
  String get switchLanguage => 'ভাষা পরিবর্তন করুন';

  @override
  String homeGreeting(Object name) {
    return 'হাই, $name!';
  }
}
