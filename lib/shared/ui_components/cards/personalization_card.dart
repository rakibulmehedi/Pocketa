import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/ui_components/cards/interactive_card.dart';

/// Types of personalization cards
enum PersonalizationCardType {
  income,
  language,
  currency,
  preferences,
  goals,
  habits,
}

/// A specialized card for personalization options
class PersonalizationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<CardOption> options;
  final List<dynamic> selectedValues;
  final Function(List<dynamic>) onSelectionChanged;
  final bool allowMultiSelect;
  final PersonalizationCardType cardType;

  const PersonalizationCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
    this.allowMultiSelect = false,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;

    return InteractiveCard(
      title: title,
      subtitle: subtitle,
      isSelected: selectedValues.isNotEmpty,
      onTap: null, // Handled by individual options
      child: layout.isDesktop
          ? Row(
              children: options.map((option) => 
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: layout.spaceM),
                    child: _buildOptionCard(context, option),
                  ),
                ),
              ).toList(),
            )
          : Wrap(
              spacing: layout.spaceM,
              runSpacing: layout.spaceS,
              children: options.map((option) => 
                _buildOptionCard(context, option),
              ).toList(),
            ),
    );
  }

  Widget _buildOptionCard(BuildContext context, CardOption option) {
    final isSelected = selectedValues.contains(option.value);
    final layout = context.layout;

    return GestureDetector(
      onTap: () => _handleOptionTap(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(layout.spaceM),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(layout.radiusM),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (option.icon != null) ...[
              Icon(
                option.icon,
                size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: layout.spaceS),
            ],
            Text(
              option.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (option.subtitle != null) ...[
              SizedBox(height: layout.spaceS),
              Text(
                option.subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8)
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isSelected) ...[
              SizedBox(height: layout.spaceS),
              Icon(
                Icons.check_circle_rounded,
                size: layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleOptionTap(CardOption option) {
    HapticFeedback.lightImpact();
    
    if (allowMultiSelect) {
      final newValues = List<dynamic>.from(selectedValues);
      if (newValues.contains(option.value)) {
        newValues.remove(option.value);
      } else {
        newValues.add(option.value);
      }
      onSelectionChanged(newValues);
    } else {
      onSelectionChanged([option.value]);
    }
  }
}

/// Data class for card options
class CardOption {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final dynamic value;

  const CardOption({
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
  });
}
