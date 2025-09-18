# Forms

Form components for data input and validation.

## Components

- **AppTextFormField** - Enhanced text form field
- **AmountField** - Amount input with currency formatting
- **AppDateTimeField** - Date and time picker
- **AppDropdownField** - Dropdown field
- **NoteField** - Note input field

## Usage

```dart
import 'package:pocketa/shared/ui_components/forms/forms.dart';

AppTextFormField(
  label: 'Name',
  controller: nameController,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)
```