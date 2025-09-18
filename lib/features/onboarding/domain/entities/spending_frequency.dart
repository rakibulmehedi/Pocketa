/// Spending frequency enumeration for onboarding
enum SpendingFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

/// Extension methods for SpendingFrequency
extension SpendingFrequencyExtension on SpendingFrequency {
  /// Get display name for the spending frequency
  String get displayName {
    switch (this) {
      case SpendingFrequency.daily:
        return 'Daily';
      case SpendingFrequency.weekly:
        return 'Weekly';
      case SpendingFrequency.monthly:
        return 'Monthly';
      case SpendingFrequency.yearly:
        return 'Yearly';
    }
  }
  
  /// Get description for the spending frequency
  String get description {
    switch (this) {
      case SpendingFrequency.daily:
        return 'I track expenses daily';
      case SpendingFrequency.weekly:
        return 'I track expenses weekly';
      case SpendingFrequency.monthly:
        return 'I track expenses monthly';
      case SpendingFrequency.yearly:
        return 'I track expenses yearly';
    }
  }
}
