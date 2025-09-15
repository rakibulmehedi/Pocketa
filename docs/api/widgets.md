# Shared Widgets API Documentation

This document provides comprehensive API documentation for all shared widgets in the Pocketa application.

## Table of Contents

- [Custom Buttons](#custom-buttons)
- [Input Fields](#input-fields)
- [Performance Optimized Widgets](#performance-optimized-widgets)
- [Animated Components](#animated-components)
- [Custom App Bar](#custom-app-bar)
- [Snackbar System](#snackbar-system)
- [Chips](#chips)
- [Section Cards](#section-cards)
- [Icons](#icons)

## Custom Buttons

### PositiveButton

A customizable positive action button with multiple variants and sizes.

```dart
class PositiveButton extends StatelessWidget {
  const PositiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.hapticFeedback = true,
  });
}
```

**Properties:**
- `onPressed` - Callback function when button is pressed
- `child` - Widget to display inside the button
- `variant` - Button style variant (filled, outlined, text)
- `size` - Button size (small, medium, large)
- `isLoading` - Shows loading indicator when true
- `isEnabled` - Enables/disables the button
- `hapticFeedback` - Enables haptic feedback on press

**Button Variants:**
- `ButtonVariant.filled` - Solid background with text
- `ButtonVariant.outlined` - Border with transparent background
- `ButtonVariant.text` - Text-only button

**Button Sizes:**
- `ButtonSize.small` - Compact button for tight spaces
- `ButtonSize.medium` - Standard button size
- `ButtonSize.large` - Prominent button for primary actions

**Usage Example:**

```dart
PositiveButton(
  onPressed: () => _handleSave(),
  variant: ButtonVariant.filled,
  size: ButtonSize.large,
  isLoading: _isSaving,
  child: Text('Save Transaction'),
)
```

### NegativeButton

A customizable negative action button for destructive actions.

```dart
class NegativeButton extends StatelessWidget {
  const NegativeButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.hapticFeedback = true,
  });
}
```

**Usage Example:**

```dart
NegativeButton(
  onPressed: () => _handleDelete(),
  variant: ButtonVariant.outlined,
  size: ButtonSize.medium,
  child: Text('Delete'),
)
```

## Input Fields

### AppTextFormField

A comprehensive text input field with validation and customization options.

```dart
class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onSaved,
    this.variant = InputFieldVariant.outlined,
    this.size = InputFieldSize.medium,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
  });
}
```

**Properties:**
- `controller` - Text editing controller
- `label` - Field label text
- `hint` - Placeholder text
- `helperText` - Helper text below field
- `errorText` - Error message text
- `validator` - Validation function
- `variant` - Field style variant
- `size` - Field size
- `keyboardType` - Keyboard type
- `obscureText` - Hide text (for passwords)
- `maxLines` - Maximum number of lines
- `maxLength` - Maximum character count
- `prefixIcon` - Icon before text
- `suffixIcon` - Icon after text

**Input Field Variants:**
- `InputFieldVariant.outlined` - Outlined border
- `InputFieldVariant.filled` - Filled background
- `InputFieldVariant.underlined` - Underlined style

**Input Field Sizes:**
- `InputFieldSize.small` - Compact input
- `InputFieldSize.medium` - Standard input
- `InputFieldSize.large` - Large input

**Usage Example:**

```dart
AppTextFormField(
  controller: _amountController,
  label: 'Amount',
  hint: 'Enter amount',
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  },
  prefixIcon: Icons.attach_money,
  variant: InputFieldVariant.outlined,
  size: InputFieldSize.medium,
)
```

### AppAmountField

Specialized input field for monetary amounts.

```dart
class AppAmountField extends StatelessWidget {
  const AppAmountField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.currency = 'BDT',
    this.validator,
    this.onChanged,
  });
}
```

### AppDateTimeField

Date and time picker input field.

```dart
class AppDateTimeField extends StatelessWidget {
  const AppDateTimeField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
  });
}
```

### AppDropdown

Custom dropdown field with search and multi-select support.

```dart
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.validator,
    this.searchable = false,
    this.multiSelect = false,
  });
}
```

## Performance Optimized Widgets

### PerformanceOptimizedWidget

Base widget for complex widgets that manage resources.

```dart
abstract class PerformanceOptimizedWidget extends StatefulWidget {
  const PerformanceOptimizedWidget({super.key});
}
```

### PerformanceOptimizedMixin

Mixin that provides automatic resource disposal.

```dart
mixin PerformanceOptimizedMixin<W extends StatefulWidget> on State<W> {
  void registerDisposable(Disposable disposable);
  void registerDisposables(List<Disposable> disposables);
  T createMemoized<T extends Disposable>(T Function() factory);
}
```

**Usage Example:**

```dart
class MyComplexWidget extends PerformanceOptimizedWidget {
  @override
  State<MyComplexWidget> createState() => _MyComplexWidgetState();
}

class _MyComplexWidgetState extends State<MyComplexWidget> 
    with PerformanceOptimizedMixin {
  
  @override
  void initState() {
    super.initState();
    
    // Register disposables
    registerDisposable(AnimationController());
    registerDisposable(StreamController());
  }
}
```

### DisposableController

Base class for controllers that need disposal.

```dart
abstract class DisposableController extends Disposable {
  bool get isDisposed;
  void throwIfDisposed();
  void onDispose();
}
```

## Animated Components

### AnimatedComponents

Static class providing reusable animation components.

```dart
class AnimatedComponents {
  static Widget fadeSlideTransition({
    required Animation<double> fadeAnimation,
    required Animation<Offset> slideAnimation,
    required Widget child,
    Offset slideOffset = const Offset(0, 0.3),
  });
  
  static Widget scaleTransition({
    required Animation<double> scaleAnimation,
    required Widget child,
    double minScale = 0.8,
    double maxScale = 1.0,
  });
  
  static Widget rotationTransition({
    required Animation<double> rotationAnimation,
    required Widget child,
    double maxRotation = 0.1,
  });
  
  static List<Widget> staggeredChildren({
    required List<Widget> children,
    Duration delay = const Duration(milliseconds: 100),
  });
}
```

**Usage Example:**

```dart
AnimatedBuilder(
  animation: _animationController,
  builder: (context, child) {
    return AnimatedComponents.fadeSlideTransition(
      fadeAnimation: _fadeAnimation,
      slideAnimation: _slideAnimation,
      child: MyWidget(),
    );
  },
)
```

## Custom App Bar

### CustomAppBar

Custom app bar with consistent styling and responsive behavior.

```dart
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation,
    this.centerTitle,
  });
}
```

### CustomSilverAppBar

Sliver app bar for scrollable content.

```dart
class CustomSilverAppBar extends StatelessWidget {
  const CustomSilverAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.expandedHeight,
    this.flexibleSpace,
  });
}
```

## Snackbar System

### SnackbarService

Centralized snackbar service with multiple types and customization options.

```dart
class SnackbarService {
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  });
  
  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  });
  
  static void showWarning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  });
  
  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  });
  
  static void showCustom(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  });
}
```

**Snackbar Types:**
- `SnackbarType.success` - Green success message
- `SnackbarType.error` - Red error message
- `SnackbarType.warning` - Orange warning message
- `SnackbarType.info` - Blue info message

**Usage Example:**

```dart
// Success snackbar
SnackbarService.showSuccess(
  context,
  message: 'Transaction saved successfully',
  actionLabel: 'View',
  onAction: () => _viewTransaction(),
);

// Error snackbar with retry
SnackbarService.showError(
  context,
  message: 'Failed to save transaction',
  actionLabel: 'Retry',
  onAction: () => _retrySave(),
  duration: Duration(seconds: 5),
);
```

## Chips

### CustomChip

Customizable chip widget for tags and selections.

```dart
class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.selected = false,
    this.variant = ChipVariant.filled,
    this.size = ChipSize.medium,
  });
}
```

**Chip Variants:**
- `ChipVariant.filled` - Filled background
- `ChipVariant.outlined` - Outlined border
- `ChipVariant.flat` - Flat style

**Chip Sizes:**
- `ChipSize.small` - Compact chip
- `ChipSize.medium` - Standard chip
- `ChipSize.large` - Large chip

## Section Cards

### SectionCard

Card widget for grouping related content.

```dart
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.actions,
    this.padding,
    this.margin,
    this.elevation,
  });
}
```

## Icons

### CustomIcons

Custom icon set for the application.

```dart
class CustomIcons {
  static const IconData transaction = IconData(0xe900, fontFamily: 'CustomIcons');
  static const IconData wallet = IconData(0xe901, fontFamily: 'CustomIcons');
  static const IconData category = IconData(0xe902, fontFamily: 'CustomIcons');
  // ... more icons
}
```

## Best Practices

1. **Consistent Styling**: Use the provided variants and sizes for consistency
2. **Accessibility**: Always provide meaningful labels and hints
3. **Performance**: Use PerformanceOptimizedWidget for complex widgets
4. **Validation**: Implement proper validation for input fields
5. **Error Handling**: Use the snackbar service for user feedback
6. **Responsive Design**: Consider different screen sizes when using widgets
7. **Resource Management**: Always dispose of resources properly
8. **Testing**: Test widgets with different states and configurations

## Performance Considerations

1. **Widget Reuse**: Reuse widgets instead of creating new instances
2. **Disposal**: Use PerformanceOptimizedMixin for automatic resource cleanup
3. **Animation**: Use AnimatedComponents for consistent animations
4. **Memory**: Dispose of controllers and streams properly
5. **Rebuilds**: Minimize unnecessary widget rebuilds
6. **Large Lists**: Use optimized list views for large datasets
7. **Images**: Optimize image loading and caching
8. **State Management**: Use appropriate state management patterns
