# Dialogs

Dialog components for user interactions.

## Components

- **AppDialog** - Premium interactive dialog with customizable content
- **AppConfirmationDialog** - Standard confirmation dialog

## Usage

```dart
import 'package:pocketa/shared/ui_components/dialogs/dialogs.dart';

AppDialog(
  title: 'Confirm Action',
  content: Text('Are you sure?'),
  actions: [
    TextButton(onPressed: () {}, child: Text('Cancel')),
    TextButton(onPressed: () {}, child: Text('Confirm')),
  ],
)
```