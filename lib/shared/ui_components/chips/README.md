# Chips

Chip components for feature and option selection.

## Components

- **FeatureChip** - Reusable feature chip with selection states
- **OptionChip** - Option selection chip
- **IncomeOptionChip** - Income type selection chip

## Usage

```dart
import 'package:pocketa/shared/ui_components/chips/chips.dart';

FeatureChip(
  label: 'Feature',
  icon: Icons.star,
  isSelected: isSelected,
  onTap: () => toggleSelection(),
)
```