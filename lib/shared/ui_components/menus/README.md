# Menus

Menu components for navigation and options.

## Components

- **MoreMenu** - More options menu
- **LanguageToggleButton** - Language selection button

## Usage

```dart
import 'package:pocketa/shared/ui_components/menus/menus.dart';

MoreMenu(
  items: [
    PopupMenuItem(value: 'edit', child: Text('Edit')),
    PopupMenuItem(value: 'delete', child: Text('Delete')),
  ],
  onSelected: (value) => handleSelection(value),
)
```