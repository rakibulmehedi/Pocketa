import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/l10n/app_localizations_en.dart';

void main() {
  test('new i18n keys are accessible', () {
    final l10n = AppLocalizationsEn();
    expect(l10n.newLabel, isNotEmpty);
    expect(l10n.icon, isNotEmpty);
    expect(l10n.color, isNotEmpty);
    expect(l10n.addCategory, isNotEmpty);
    expect(l10n.makeDefault, isNotEmpty);
  });
}

