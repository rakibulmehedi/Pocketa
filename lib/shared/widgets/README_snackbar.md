# Custom Snackbar System

A modern, responsive, and Fintch-friendly custom snackbar system for the Pocketa app.

## Features

- 🎨 **Modern Design**: Clean, modern UI with proper spacing and typography
- 📱 **Responsive**: Adapts to different screen sizes using the app's responsive system
- 🎯 **Fintch-Friendly**: Designed specifically for financial apps with appropriate colors and messaging
- ⚡ **Smooth Animations**: Slide-in and fade animations for better UX
- 🎭 **Multiple Types**: Success, Error, Warning, and Info snackbars
- 🔧 **Customizable**: Support for custom icons, actions, and durations
- 📱 **Haptic Feedback**: Built-in haptic feedback for better user interaction
- 🌐 **Accessible**: Proper contrast ratios and touch targets

## Usage

### Basic Usage

```dart
import 'package:pocketa/shared/services/services.dart';

// Success snackbar
SnackbarService.showSuccess(context, message: 'Transaction added successfully');

// Error snackbar
SnackbarService.showError(context, message: 'Something went wrong');

// Warning snackbar
SnackbarService.showWarning(context, message: 'Please check your input');

// Info snackbar
SnackbarService.showInfo(context, message: 'Feature coming soon');
```

### Advanced Usage

```dart
// Custom snackbar with action
SnackbarService.showError(
  context,
  message: 'Network error occurred',
  actionLabel: 'Retry',
  onAction: () {
    // Retry logic
  },
  duration: Duration(seconds: 5),
);

// Custom snackbar with custom icon
SnackbarService.showCustom(
  context,
  message: 'Custom message',
  type: SnackbarType.info,
  icon: Icons.star,
  actionLabel: 'Learn More',
  onAction: () {
    // Action logic
  },
);
```

### Convenience Methods

```dart
// Transaction-related snackbars
SnackbarService.showTransactionAdded(context);
SnackbarService.showTransactionUpdated(context);
SnackbarService.showTransactionDeleted(context);

// Wallet-related snackbars
SnackbarService.showWalletAdded(context);
SnackbarService.showWalletUpdated(context);
SnackbarService.showWalletDeleted(context);

// Common error snackbars
SnackbarService.showGenericError(context);
SnackbarService.showNetworkError(context);
SnackbarService.showValidationError(context, 'Invalid input');
SnackbarService.showFeatureInfo(context, 'Feature explanation');
```

## Snackbar Types

### Success (Green)
- Used for successful operations
- Green color scheme
- Check circle icon
- Short duration (2-3 seconds)

### Error (Red)
- Used for errors and failures
- Red color scheme
- Error outline icon
- Longer duration (4-5 seconds)

### Warning (Orange)
- Used for warnings and cautions
- Orange color scheme
- Warning icon
- Medium duration (3 seconds)

### Info (Blue)
- Used for informational messages
- Blue color scheme
- Info icon
- Short duration (2-3 seconds)

## Design System

### Colors
The snackbar system uses a carefully designed color palette that works well in both light and dark themes:

- **Success**: Green tones with proper contrast
- **Error**: Red tones with proper contrast
- **Warning**: Orange tones with proper contrast
- **Info**: Blue tones with proper contrast

### Typography
- Uses the app's typography system
- Proper font weights and sizes
- Responsive text sizing

### Spacing
- Uses the app's responsive spacing system
- Consistent padding and margins
- Proper touch targets

### Animations
- Smooth slide-in animation from the right
- Fade animation for better transitions
- Auto-dismiss with fade-out animation

## Responsive Behavior

The snackbar system automatically adapts to different screen sizes:

- **Mobile**: Full-width with proper margins
- **Tablet**: Centered with max-width constraints
- **Desktop**: Appropriate sizing and positioning

## Accessibility

- Proper contrast ratios for all color combinations
- Adequate touch targets (minimum 44x44 points)
- Screen reader friendly
- Keyboard navigation support

## Migration from Old Snackbars

Replace old `ScaffoldMessenger.showSnackBar` calls:

```dart
// Old way
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Message'),
    backgroundColor: Colors.green,
  ),
);

// New way
SnackbarService.showSuccess(context, message: 'Message');
```

## Best Practices

1. **Use appropriate types**: Choose the right snackbar type for your message
2. **Keep messages concise**: Short, clear messages work best
3. **Use actions sparingly**: Only add actions when they provide real value
4. **Consider duration**: Longer messages need longer durations
5. **Test on different screen sizes**: Ensure the snackbar works well on all devices

## Examples

### Transaction Management
```dart
// After adding a transaction
SnackbarService.showTransactionAdded(context);

// After updating a transaction
SnackbarService.showTransactionUpdated(context);

// After deleting a transaction
SnackbarService.showTransactionDeleted(context);
```

### Error Handling
```dart
try {
  await saveTransaction();
  SnackbarService.showTransactionAdded(context);
} catch (e) {
  SnackbarService.showGenericError(context);
}
```

### Form Validation
```dart
if (amount <= 0) {
  SnackbarService.showValidationError(context, 'Amount must be greater than 0');
  return;
}
```

### Feature Information
```dart
SnackbarService.showFeatureInfo(context, 'Tap and hold to edit transactions');
```
