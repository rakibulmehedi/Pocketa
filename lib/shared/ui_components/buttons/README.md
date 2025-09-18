# Buttons

Button components with multiple styles and states.

## Components

- **AppButton** - Comprehensive button with multiple styles (primary, secondary, outline, text)
- **QuickButton** - Specialized button for quick actions
- **ResponsiveIconButton** - Icon-only button that adapts to screen sizes

## Usage

```dart
import 'package:pocketa/shared/ui_components/buttons/buttons.dart';

AppButton(
  text: 'Save',
  onPressed: () => saveData(),
  style: AppButtonStyle.primary,
  icon: Icons.save,
)
```