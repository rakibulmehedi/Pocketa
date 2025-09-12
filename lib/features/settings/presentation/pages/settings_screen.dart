// ──────────────────────────────────────────────────────────────────────────────
// Settings Screen - Pocketa
// @Rakibul Islam Mehedi - rakibulmehedi.dev@gmail.com
// ──────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/providers/celebration_preferences_provider.dart';
import 'package:pocketa/core/providers/theme_provider.dart';
import 'package:pocketa/core/locale/local_notifier.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/section_card.dart';
import 'package:pocketa/shared/ui/motion.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(layout.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            SectionCard(
              children: [
                Text(
                  l10n.appearance,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: layout.spaceL),
                
                // Theme Toggle
                _buildThemeSection(context, ref, l10n, theme),
                
                SizedBox(height: layout.spaceL),
                
                // Language Toggle
                _buildLanguageSection(context, ref, l10n, theme),
              ],
            ),
            
            SizedBox(height: layout.spaceL),
            
            // Celebration Section
            SectionCard(
              children: [
                Text(
                  'Celebration',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: layout.spaceL),
                
                // Celebration Preferences
                _buildCelebrationSection(context, ref, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.theme,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildThemeOption(
                context,
                themeMode == ThemeMode.light,
                l10n.lightMode,
                Icons.light_mode,
                () => themeNotifier.setLight(),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildThemeOption(
                context,
                themeMode == ThemeMode.dark,
                l10n.darkMode,
                Icons.dark_mode,
                () => themeNotifier.setDark(),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildThemeOption(
                context,
                themeMode == ThemeMode.system,
                l10n.systemDefault,
                Icons.settings_system_daydream,
                () => themeNotifier.setSystem(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    bool isSelected,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTap(
      scale: 0.98,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildLanguageOption(
                context,
                currentLocale.languageCode == 'en',
                l10n.language_en,
                'EN',
                () => localeNotifier.setLocale(const Locale('en')),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildLanguageOption(
                context,
                currentLocale.languageCode == 'bn',
                l10n.language_bn,
                'বাংলা',
                () => localeNotifier.setLocale(const Locale('bn')),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    bool isSelected,
    String label,
    String code,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTap(
      scale: 0.98,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              code,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final preferences = ref.watch(celebrationPreferencesProvider);
    final notifier = ref.read(celebrationPreferencesProvider.notifier);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.celebration_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Celebration Experience',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        
        // Celebration Sounds Toggle
        SwitchListTile(
          title: Text(
            'Celebration Sounds',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Subtle chimes for achievements and milestones\nRespects silent mode and system volume',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          value: preferences.enableCelebrationSound,
          onChanged: (value) {
            notifier.setCelebrationSoundEnabled(value);
          },
          activeColor: colorScheme.primary,
          secondary: Icon(
            Icons.volume_up_outlined,
            color: preferences.enableCelebrationSound 
                ? colorScheme.primary 
                : colorScheme.onSurfaceVariant,
          ),
        ),
        
        Divider(height: 1),
        
        // Haptic Feedback Toggle
        SwitchListTile(
          title: Text(
            'Haptic Feedback',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Gentle vibrations for interactions and celebrations\nEnhances the celebration experience',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          value: preferences.enableHaptics,
          onChanged: (value) {
            notifier.setHapticsEnabled(value);
          },
          activeColor: colorScheme.primary,
          secondary: Icon(
            Icons.vibration,
            color: preferences.enableHaptics 
                ? colorScheme.primary 
                : colorScheme.onSurfaceVariant,
          ),
        ),
        
        Divider(height: 1),
        
        // Confetti Toggle
        SwitchListTile(
          title: Text(
            'Confetti Effects',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Colorful animations for celebrations\nRespects reduced motion accessibility',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          value: preferences.enableConfetti,
          onChanged: (value) {
            notifier.setConfettiEnabled(value);
          },
          activeColor: colorScheme.primary,
          secondary: Icon(
            Icons.celebration,
            color: preferences.enableConfetti 
                ? colorScheme.primary 
                : colorScheme.onSurfaceVariant,
          ),
        ),
        
        // Info Card
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: colorScheme.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'All celebration features respect your device\'s accessibility settings and silent mode.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
