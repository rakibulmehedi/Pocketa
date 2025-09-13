# PocketA Design System Implementation Guide
## Practical Code Examples & Migration Strategies

---

## 🚀 Quick Start

### 1. Theme Setup

#### Updated App Theme (lib/core/theme/app_theme.dart)
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme = isDark ? _darkScheme : _lightScheme;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 3,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: isDark ? Colors.black54 : const Color(0x14102028),
    ),
    
    // Button Themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(0, 48),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: colorScheme.outline),
        minimumSize: const Size(0, 48),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(0, 40),
      ),
    ),
    
    // Input Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      floatingLabelStyle: TextStyle(
        color: colorScheme.primary, 
        fontWeight: FontWeight.w600
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 1.8),
      ),
    ),
    
    // Divider Theme
    dividerColor: colorScheme.outline.withOpacity(isDark ? 0.16 : 0.08),
  );
}

// Light Color Scheme
const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0EA5E9),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFE0F2FE),
  onPrimaryContainer: Color(0xFF0B6A8F),
  secondary: Color(0xFF10B981),
  onSecondary: Color(0xFF062D20),
  error: Color(0xFFEF4444),
  onError: Colors.white,
  background: Color(0xFFF7F9FB),
  onBackground: Color(0xFF0F172A),
  surface: Colors.white,
  onSurface: Color(0xFF121417),
  surfaceVariant: Color(0xFFF3F5F7),
  onSurfaceVariant: Color(0xFF344055),
  outline: Color(0xFFE5EAF0),
  shadow: Color(0x14102028),
  tertiary: Color(0xFF94A3B8),
  onTertiary: Color(0xFF0F172A),
);

// Dark Color Scheme
const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF38BDF8),
  onPrimary: Color(0xFF0B1220),
  primaryContainer: Color(0xFF0B3A53),
  onPrimaryContainer: Color(0xFFE0F2FE),
  secondary: Color(0xFF34D399),
  onSecondary: Color(0xFF061A14),
  error: Color(0xFFF87171),
  onError: Color(0xFF1C0C0C),
  background: Color(0xFF070A0F),
  onBackground: Color(0xFFE6EDF5),
  surface: Color(0xFF0B0F14),
  onSurface: Color(0xFFE5EAF0),
  surfaceVariant: Color(0xFF121821),
  onSurfaceVariant: Color(0xFFC7D1DE),
  outline: Color(0xFF1E2631),
  shadow: Colors.black54,
  tertiary: Color(0xFF64748B),
  onTertiary: Color(0xFFE2E8F0),
);
```

### 2. Background Gradient Implementation

#### App Scaffold with Gradient (lib/shared/ui/app_scaffold.dart)
```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? footer;
  final PreferredSizeWidget? appBar;
  final bool useGradient;

  const AppScaffold({
    super.key,
    required this.body,
    this.footer,
    this.appBar,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: useGradient
          ? _GradientBackground(child: body)
          : body,
      bottomNavigationBar: footer,
    );
  }
}

class _GradientBackground extends StatelessWidget {
  final Widget child;
  const _GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF070A0F),
                  const Color(0xFF0B0F14),
                ]
              : [
                  const Color(0xFFF7F9FB),
                  Colors.white,
                ],
        ),
      ),
      child: child,
    );
  }
}
```

### 3. Footer CTA Bar Implementation

#### Updated FooterCtaBar (lib/shared/ui/footer_cta_bar.dart)
```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class FooterCtaBar extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? backLabel;
  final VoidCallback? onBack;
  final bool showBack;
  final IconData backIcon;

  const FooterCtaBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.backLabel,
    this.onBack,
    this.showBack = true,
    this.backIcon = Icons.arrow_back_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.85),
                    border: Border.all(
                      color: cs.outline.withOpacity(
                        Theme.of(context).brightness == Brightness.dark ? 0.16 : 0.08,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow,
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        if (showBack)
                          OutlinedButton.icon(
                            onPressed: onBack ?? Navigator.of(context).maybePop,
                            icon: Icon(backIcon),
                            label: Text(backLabel ?? 'Back'),
                          ),
                        const Spacer(),
                        FilledButton(
                          onPressed: onPrimary,
                          child: Text(primaryLabel),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🎨 Component Examples

### 1. Button Components

#### Primary Action Button
```dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          : Icon(icon),
      label: Text(label),
    );
  }
}
```

#### Secondary Action Button
```dart
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
```

### 2. Card Components

#### Standard Card
```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin ?? const EdgeInsets.all(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      );
    }

    return card;
  }
}
```

#### Transaction Card
```dart
class TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final String category;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.category,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (iconColor ?? cs.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? cs.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3. Input Components

#### Amount Input Field
```dart
class AmountInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final String currency;
  final ValueChanged<String>? onChanged;

  const AmountInputField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.currency = '৳',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixText: '$currency ',
        prefixStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }
}
```

---

## 🎭 Motion & Animation

### 1. Animation Wrappers

#### Fade Slide Animation
```dart
class FadeSlide extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  const FadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 220),
    this.offset = const Offset(0, 20),
  });

  @override
  State<FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<FadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
```

#### Scale Tap Animation
```dart
class ScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;

  const ScaleTap({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
```

### 2. Confetti Animation

#### Confetti Widget
```dart
class ConfettiWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final int particleCount;
  final Duration duration;

  const ConfettiWidget({
    super.key,
    this.onComplete,
    this.particleCount = 24,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<ConfettiParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _generateParticles();
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  void _generateParticles() {
    final random = Random();
    final cs = Theme.of(context).colorScheme;
    final colors = [cs.primary, cs.secondary];

    for (int i = 0; i < widget.particleCount; i++) {
      particles.add(ConfettiParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        color: colors[random.nextInt(colors.length)],
        angle: random.nextDouble() * 2 * math.pi,
        velocity: 0.5 + random.nextDouble() * 0.5,
        gravity: 0.5 + random.nextDouble() * 0.3,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            particles: particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double angle;
  final double velocity;
  final double gravity;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.angle,
    required this.velocity,
    required this.gravity,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height + (progress * progress * 200);
      final radius = 4.0 * (1.0 - progress);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

---

## 🌍 Internationalization

### 1. Localization Setup

#### App Localizations (lib/l10n/app_localizations.dart)
```dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Onboarding
  String get onb_welcome_title => _localizedValues[locale.languageCode]?['onb_welcome_title'] ?? 'Welcome to PocketA';
  String get onb_welcome_subtitle => _localizedValues[locale.languageCode]?['onb_welcome_subtitle'] ?? 'Take control of your finances';
  String get onb_continue => _localizedValues[locale.languageCode]?['onb_continue'] ?? 'Continue';
  String get onb_back => _localizedValues[locale.languageCode]?['onb_back'] ?? 'Back';
  
  // Progress
  String onb_progress_step(int current, int total) => 
    _localizedValues[locale.languageCode]?['onb_progress_step']?.replaceAll('{current}', current.toString()).replaceAll('{total}', total.toString()) ?? 
    'Step $current of $total';
  
  String onb_progress_percentage(int percentage) => 
    _localizedValues[locale.languageCode]?['onb_progress_percentage']?.replaceAll('{percentage}', percentage.toString()) ?? 
    '$percentage%';

  // Common
  String get retry => _localizedValues[locale.languageCode]?['retry'] ?? 'Retry';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'onb_welcome_title': 'Welcome to PocketA',
      'onb_welcome_subtitle': 'Take control of your finances',
      'onb_continue': 'Continue',
      'onb_back': 'Back',
      'onb_progress_step': 'Step {current} of {total}',
      'onb_progress_percentage': '{percentage}%',
      'retry': 'Retry',
      'save': 'Save',
      'cancel': 'Cancel',
    },
    'bn': {
      'onb_welcome_title': 'পকেটএ-তে স্বাগতম',
      'onb_welcome_subtitle': 'আপনার আর্থিক অবস্থা নিয়ন্ত্রণ করুন',
      'onb_continue': 'চালিয়ে যান',
      'onb_back': 'ফিরে যান',
      'onb_progress_step': '{current}/{total} ধাপ',
      'onb_progress_percentage': '{percentage}%',
      'retry': 'পুনরায় চেষ্টা করুন',
      'save': 'সংরক্ষণ করুন',
      'cancel': 'বাতিল করুন',
    },
  };
}
```

### 2. Currency Formatting

#### Currency Formatter
```dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      locale: _getLocaleForCurrency(currencyCode),
      symbol: _getSymbolForCurrency(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String _getLocaleForCurrency(String currencyCode) {
    switch (currencyCode) {
      case 'BDT':
        return 'bn_BD';
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'en_GB';
      default:
        return 'en_US';
    }
  }

  static String _getSymbolForCurrency(String currencyCode) {
    switch (currencyCode) {
      case 'BDT':
        return '৳';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return currencyCode;
    }
  }
}
```

---

## 📱 Responsive Implementation

### 1. Responsive Layout Helper

#### Responsive Builder
```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AppSize layout) builder;
  final Widget? child;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    return builder(context, layout);
  }
}

// Usage
ResponsiveBuilder(
  builder: (context, layout) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(layout.spaceL),
          child: content,
        ),
      ],
    );
  },
)
```

### 2. Responsive Text Styles

#### Responsive Text Helper
```dart
extension ResponsiveText on BuildContext {
  TextStyle responsiveTextStyle({
    required TextStyle phone,
    TextStyle? tablet,
    TextStyle? desktop,
  }) {
    final device = this.device;
    
    switch (device) {
      case DeviceSize.phone:
        return phone;
      case DeviceSize.tablet:
        return tablet ?? phone;
      case DeviceSize.desktop:
        return desktop ?? tablet ?? phone;
    }
  }
}

// Usage
Text(
  'Hello World',
  style: context.responsiveTextStyle(
    phone: Theme.of(context).textTheme.bodyMedium!,
    tablet: Theme.of(context).textTheme.bodyLarge!,
    desktop: Theme.of(context).textTheme.headlineSmall!,
  ),
)
```

---

## 🔧 Migration Strategy

### 1. Phase 1: Theme Migration

#### Step 1: Update App Theme
```dart
// 1. Replace existing theme with new buildAppTheme function
// 2. Update color schemes to match design tokens
// 3. Test light and dark themes
```

#### Step 2: Update Scaffold Backgrounds
```dart
// 1. Replace hardcoded Scaffold backgrounds
// 2. Use AppScaffold with gradient support
// 3. Ensure text readability on all surfaces
```

### 2. Phase 2: Component Migration

#### Step 1: Update Footer Components
```dart
// 1. Replace FooterCtas with FooterCtaBar
// 2. Update all onboarding screens
// 3. Test responsive behavior
```

#### Step 2: Update Button Components
```dart
// 1. Use new button themes
// 2. Update custom button components
// 3. Test all button states
```

### 3. Phase 3: Motion Integration

#### Step 1: Add Animation Wrappers
```dart
// 1. Wrap existing widgets with FadeSlide
// 2. Add ScaleTap to interactive elements
// 3. Test reduced motion support
```

#### Step 2: Add Confetti Animation
```dart
// 1. Add ConfettiWidget to success states
// 2. Limit duration to 0.6s
// 3. Test performance
```

---

## 🧪 Testing Checklist

### 1. Visual Testing

#### Light Theme
- [ ] All screens render correctly
- [ ] Text is readable on all backgrounds
- [ ] Colors match design tokens
- [ ] Spacing follows 8px grid
- [ ] Shadows and elevations are consistent

#### Dark Theme
- [ ] All screens render correctly
- [ ] Contrast ratios meet WCAG 2.1 AA
- [ ] Text is readable on all surfaces
- [ ] Colors are appropriate for dark mode

### 2. Responsive Testing

#### Mobile (320px - 599px)
- [ ] Layout works on small screens
- [ ] Touch targets are ≥ 44px
- [ ] Text is readable without zooming
- [ ] Navigation is accessible

#### Tablet (600px - 839px)
- [ ] Layout adapts to larger screens
- [ ] Spacing is appropriate
- [ ] Multi-column layouts work
- [ ] Touch targets are appropriate

#### Desktop (840px+)
- [ ] Layout uses full width effectively
- [ ] Sidebar navigation works
- [ ] Hover states are functional
- [ ] Content doesn't overflow

### 3. Accessibility Testing

#### Screen Reader
- [ ] All interactive elements are labeled
- [ ] Navigation is logical
- [ ] Content is announced correctly
- [ ] Focus order is logical

#### Keyboard Navigation
- [ ] All interactive elements are focusable
- [ ] Tab order is logical
- [ ] Focus indicators are visible
- [ ] Keyboard shortcuts work

#### Color Contrast
- [ ] Normal text: ≥ 4.5:1
- [ ] Large text: ≥ 3:1
- [ ] UI components: ≥ 3:1
- [ ] Error states are clearly visible

### 4. Performance Testing

#### Animation Performance
- [ ] No layout jank during animations
- [ ] Animations respect reduced motion
- [ ] Confetti doesn't impact performance
- [ ] Smooth 60fps animations

#### Memory Usage
- [ ] No memory leaks in animations
- [ ] Images are optimized
- [ ] Gradients don't impact performance
- [ ] Efficient widget rebuilds

---

## 🚀 Deployment Checklist

### 1. Pre-deployment
- [ ] All tests pass
- [ ] Design review completed
- [ ] Accessibility audit passed
- [ ] Performance benchmarks met
- [ ] Localization verified

### 2. Deployment
- [ ] Theme changes deployed
- [ ] Component updates live
- [ ] Motion features enabled
- [ ] Analytics tracking updated

### 3. Post-deployment
- [ ] Monitor user feedback
- [ ] Track performance metrics
- [ ] Watch for accessibility issues
- [ ] Plan next iteration

---

*This implementation guide provides practical code examples and step-by-step migration strategies for implementing the PocketA design system. Follow these patterns to ensure consistency and maintainability across the application.*
