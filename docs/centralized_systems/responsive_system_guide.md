# Responsive System Implementation Guide
## PocketA - Advanced Responsive Design System

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Breakpoint System](#breakpoint-system)
4. [Device Detection](#device-detection)
5. [Scaling System](#scaling-system)
6. [Layout Utilities](#layout-utilities)
7. [Implementation Examples](#implementation-examples)
8. [Performance Optimization](#performance-optimization)
9. [Testing Responsive Design](#testing-responsive-design)
10. [Migration Guide](#migration-guide)
11. [Reusable Package Setup](#reusable-package-setup)

---

## 🎯 Overview

The PocketA Responsive System is a comprehensive solution for creating adaptive, scalable user interfaces across all device types. It provides intelligent scaling, breakpoint management, and layout utilities that ensure consistent user experiences from mobile phones to desktop computers.

### Key Features
- **Intelligent Scaling**: Automatic UI scaling based on device characteristics
- **Breakpoint Management**: Flexible breakpoint system for different screen sizes
- **Device Detection**: Quick device type identification and responsive branching
- **Layout Utilities**: Comprehensive spacing, sizing, and layout helpers
- **Performance Optimized**: Single MediaQuery read with efficient caching
- **Accessibility Support**: Respects system text scaling and accessibility settings

---

## 🏗️ System Architecture

### Core Components

```dart
// lib/core/responsive/responsive.dart
class Responsive extends StatelessWidget {
  final Widget child;
  final bool respectSystemTextScale;
  final double minTextScale;
  final double maxTextScale;
  final double? platformUiScaleOverride;

  const Responsive.builder({
    super.key,
    required this.child,
    this.respectSystemTextScale = true,
    this.minTextScale = 0.85,
    this.maxTextScale = 1.30,
    this.platformUiScaleOverride,
  });
}
```

### Internal Scope Management

```dart
class _ResponsiveScope extends InheritedWidget {
  final DeviceSize device;
  final double viewportWidth;
  final double viewportHeight;
  final AppSize layout;

  const _ResponsiveScope({
    required this.device,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.layout,
    required super.child,
  });
}
```

---

## 📱 Breakpoint System

### Breakpoint Definitions

```dart
enum AppBreakpoint { compact, mobile, tablet, desktop }

// Breakpoint thresholds (based on shortest side for rotation safety)
const Map<AppBreakpoint, double> breakpointThresholds = {
  AppBreakpoint.compact: 360.0,   // Small phones
  AppBreakpoint.mobile: 600.0,    // Standard phones
  AppBreakpoint.tablet: 1024.0,   // Tablets
  AppBreakpoint.desktop: 1200.0,  // Desktop screens
};
```

### Device Size Classification

```dart
enum DeviceSize { phone, tablet, desktop }

// Device classification based on viewport width
DeviceSize getDeviceSize(double viewportWidth) {
  if (viewportWidth >= 1024) return DeviceSize.desktop;
  if (viewportWidth >= 600) return DeviceSize.tablet;
  return DeviceSize.phone;
}
```

### Breakpoint Usage Examples

```dart
// Using breakpoints in widgets
Widget build(BuildContext context) {
  final breakpoint = context.layout.breakpoint;
  
  return switch (breakpoint) {
    AppBreakpoint.compact => CompactLayout(),
    AppBreakpoint.mobile => MobileLayout(),
    AppBreakpoint.tablet => TabletLayout(),
    AppBreakpoint.desktop => DesktopLayout(),
  };
}

// Conditional rendering based on breakpoint
Widget build(BuildContext context) {
  final isDesktop = context.layout.isDesktop;
  
  return Row(
    children: [
      if (isDesktop) Sidebar(),
      Expanded(child: MainContent()),
    ],
  );
}
```

---

## 🔍 Device Detection

### Quick Device Detection

```dart
// Lean accessors for quick device detection
extension ResponsiveContextLeanX on BuildContext {
  DeviceSize get device => Responsive._of(this).device;
  double get vw => Responsive._of(this).viewportWidth;
  double get vh => Responsive._of(this).viewportHeight;
}

// Usage examples
Widget build(BuildContext context) {
  final device = context.device;
  final viewportWidth = context.vw;
  final viewportHeight = context.vh;
  
  return switch (device) {
    DeviceSize.phone => PhoneLayout(),
    DeviceSize.tablet => TabletLayout(),
    DeviceSize.desktop => DesktopLayout(),
  };
}
```

### Device-Specific Logic

```dart
// Device-specific implementations
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final device = context.device;
    
    return switch (device) {
      DeviceSize.phone => _buildPhoneLayout(context),
      DeviceSize.tablet => _buildTabletLayout(context),
      DeviceSize.desktop => _buildDesktopLayout(context),
    };
  }
  
  Widget _buildPhoneLayout(BuildContext context) {
    return Column(
      children: [
        Header(),
        Expanded(child: Content()),
        BottomNavigation(),
      ],
    );
  }
  
  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Sidebar(),
        Expanded(child: Content()),
      ],
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Sidebar(),
        Expanded(child: Content()),
        RightPanel(),
      ],
    );
  }
}
```

---

## 📏 Scaling System

### UI Scaling

```dart
// UI scaling based on device characteristics
class AppSize {
  final double uiScale;
  final double textScale;
  
  // Gentle UI scaling toward reference width (390px)
  double get baseScale => (screenWidth / 390.0).clamp(0.84, 1.42);
  
  // Breakpoint boost for larger screens
  double get breakpointBoost => switch (breakpoint) {
    AppBreakpoint.compact => 0.96,
    AppBreakpoint.mobile => 1.00,
    AppBreakpoint.tablet => 1.08,
    AppBreakpoint.desktop => 1.12,
  };
  
  // Final UI scale
  double get finalUiScale => baseScale * breakpointBoost * platformBoost;
}
```

### Text Scaling

```dart
// Text scaling with accessibility support
class AppSize {
  // Respect system text scale then clamp
  double get rawTextScale => 
      (respectSystemTextScale ? systemTextScale : 1.0) * uiScale;
  
  double get finalTextScale => 
      rawTextScale.clamp(minTextScale, maxTextScale);
}

// Usage examples
Text(
  'Responsive Text',
  style: TextStyle(
    fontSize: 16.0 * context.layout.textScale,
  ),
);

// Or use the shorthand
Text(
  'Responsive Text',
  style: TextStyle(
    fontSize: 16.sp(context), // 16 * textScale
  ),
);
```

### Scaling Utilities

```dart
// Numeric scaling helpers
extension NumSizeX on num {
  double rem(BuildContext context) => toDouble() * context.layout.rem();
  double sp(BuildContext context) => toDouble() * context.layout.textScale;
  double ic(BuildContext context) => toDouble() * context.layout.uiScale;
  
  // Viewport-based sizing
  double w(BuildContext context) => toDouble() * context.layout.screenWidth;
  double h(BuildContext context) => toDouble() * context.layout.screenHeight;
}

// Usage examples
SizedBox(
  width: 200.rem(context),  // 200 * 8 * uiScale
  height: 100.sp(context),  // 100 * textScale
  child: Icon(
    Icons.add,
    size: 24.ic(context),   // 24 * uiScale
  ),
);
```

---

## 🎨 Layout Utilities

### Spacing System

```dart
class AppSize {
  // 8pt baseline spacing system
  double rem([double n = 1]) => 8.0 * n * uiScale;
  
  // Predefined spacing tokens
  double get spaceXs => rem(0.5);  // 4px
  double get spaceS => rem(1);     // 8px
  double get spaceM => rem(1.5);   // 12px
  double get spaceL => rem(2);     // 16px
  double get spaceXl => rem(3);    // 24px
  double get space2xl => rem(4);   // 32px
  double get space3xl => rem(6);   // 48px
}

// Usage examples
Padding(
  padding: EdgeInsets.all(context.layout.spaceL),
  child: Text('Content'),
);

SizedBox(
  height: context.layout.spaceXl,
  child: Divider(),
);
```

### Responsive Padding and Margins

```dart
class AppSize {
  // Responsive padding helpers
  EdgeInsets insetsAll(double n) => EdgeInsets.all(rem(n));
  EdgeInsets insetsSymmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: rem(h), vertical: rem(v));
  EdgeInsets insetsOnly({
    double l = 0, double t = 0, double r = 0, double b = 0
  }) => EdgeInsets.fromLTRB(rem(l), rem(t), rem(r), rem(b));
  
  // Page gutter with safe area consideration
  EdgeInsets get pageGutter => EdgeInsets.fromLTRB(
    safeLeft + gutter,
    safeTop + gutterTop,
    safeRight + gutter,
    safeBottom + gutterBottom,
  );
}

// Usage examples
Container(
  padding: context.layout.insetsSymmetric(h: 2, v: 1),
  margin: context.layout.insetsOnly(t: 1, b: 2),
  child: Text('Responsive Container'),
);

// Full page padding
Padding(
  padding: context.layout.pageGutter,
  child: PageContent(),
);
```

### Grid System

```dart
class AppSize {
  // Responsive column calculation
  int columnsFor(double minTileWidth) {
    final usable = screenWidth - (safeLeft + safeRight) - gutter * 2;
    return math.max(1, (usable / minTileWidth).floor());
  }
  
  // Responsive sizing
  double responsiveSize({
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    return switch (breakpoint) {
      AppBreakpoint.compact || AppBreakpoint.mobile => phone * uiScale,
      AppBreakpoint.tablet => tablet * uiScale,
      AppBreakpoint.desktop => desktop * uiScale,
    };
  }
}

// Usage examples
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.layout.columnsFor(200.0),
    childAspectRatio: 1.2,
    crossAxisSpacing: context.layout.spaceM,
    mainAxisSpacing: context.layout.spaceM,
  ),
  itemBuilder: (context, index) => GridItem(),
);

// Responsive sizing
Container(
  width: context.layout.responsiveSize(
    phone: 100.0,
    tablet: 150.0,
    desktop: 200.0,
  ),
  height: context.layout.responsiveSize(
    phone: 80.0,
    tablet: 120.0,
    desktop: 160.0,
  ),
  child: Content(),
);
```

---

## 🚀 Implementation Examples

### Complete Responsive Layout

```dart
class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final device = context.device;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: layout.pageGutter,
          child: Column(
            children: [
              _buildHeader(context, layout),
              SizedBox(height: layout.spaceL),
              Expanded(
                child: _buildContent(context, layout, device),
              ),
              if (device == DeviceSize.phone) 
                _buildBottomNavigation(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, AppSize layout) {
    return Row(
      children: [
        Icon(
          Icons.menu,
          size: layout.iconL,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: layout.spaceM),
        Expanded(
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24.sp(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (layout.isDesktop) ...[
          Spacer(),
          _buildDesktopActions(context),
        ],
      ],
    );
  }
  
  Widget _buildContent(BuildContext context, AppSize layout, DeviceSize device) {
    return switch (device) {
      DeviceSize.phone => _buildPhoneContent(context, layout),
      DeviceSize.tablet => _buildTabletContent(context, layout),
      DeviceSize.desktop => _buildDesktopContent(context, layout),
    };
  }
  
  Widget _buildPhoneContent(BuildContext context, AppSize layout) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatsGrid(context, layout, columns: 2),
          SizedBox(height: layout.spaceL),
          _buildRecentTransactions(context, layout),
        ],
      ),
    );
  }
  
  Widget _buildTabletContent(BuildContext context, AppSize layout) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildStatsGrid(context, layout, columns: 3),
        ),
        SizedBox(width: layout.spaceL),
        Expanded(
          flex: 1,
          child: _buildRecentTransactions(context, layout),
        ),
      ],
    );
  }
  
  Widget _buildDesktopContent(BuildContext context, AppSize layout) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildStatsGrid(context, layout, columns: 4),
        ),
        SizedBox(width: layout.spaceXl),
        Expanded(
          flex: 2,
          child: _buildRecentTransactions(context, layout),
        ),
        SizedBox(width: layout.spaceL),
        Expanded(
          flex: 1,
          child: _buildQuickActions(context, layout),
        ),
      ],
    );
  }
}
```

### Responsive Form Layout

```dart
class ResponsiveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final device = context.device;
    
    return Padding(
      padding: layout.pageGutter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Transaction',
            style: TextStyle(
              fontSize: 28.sp(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: layout.spaceL),
          _buildFormFields(context, layout, device),
          SizedBox(height: layout.spaceXl),
          _buildActionButtons(context, layout, device),
        ],
      ),
    );
  }
  
  Widget _buildFormFields(BuildContext context, AppSize layout, DeviceSize device) {
    final isWide = device == DeviceSize.desktop || 
                   (device == DeviceSize.tablet && layout.orientation == Orientation.landscape);
    
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildAmountField(context, layout),
                SizedBox(height: layout.spaceM),
                _buildCategoryField(context, layout),
              ],
            ),
          ),
          SizedBox(width: layout.spaceL),
          Expanded(
            child: Column(
              children: [
                _buildDateField(context, layout),
                SizedBox(height: layout.spaceM),
                _buildDescriptionField(context, layout),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildAmountField(context, layout),
          SizedBox(height: layout.spaceM),
          _buildCategoryField(context, layout),
          SizedBox(height: layout.spaceM),
          _buildDateField(context, layout),
          SizedBox(height: layout.spaceM),
          _buildDescriptionField(context, layout),
        ],
      );
    }
  }
}
```

---

## ⚡ Performance Optimization

### Efficient MediaQuery Usage

```dart
// Single MediaQuery read at the top level
class Responsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        // Single MediaQuery read - cached for entire subtree
        final mq = MediaQuery.of(ctx);
        final appSize = _calculateAppSize(mq, constraints);
        
        return _ResponsiveScope(
          device: appSize.device,
          viewportWidth: constraints.maxWidth,
          viewportHeight: constraints.maxHeight,
          layout: appSize,
          child: child,
        );
      },
    );
  }
}
```

### Caching Responsive Values

```dart
// Cache frequently used responsive values
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    // Cache values to avoid repeated calculations
    final cardPadding = layout.insetsAll(2);
    final iconSize = layout.iconL;
    final textStyle = TextStyle(fontSize: 16.sp(context));
    
    return Container(
      padding: cardPadding,
      child: Row(
        children: [
          Icon(Icons.add, size: iconSize),
          Text('Cached values', style: textStyle),
        ],
      ),
    );
  }
}
```

### Const Constructors

```dart
// Use const constructors where possible
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    super.key,
    required this.title,
    required this.content,
  });
  
  final String title;
  final Widget content;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.layout.spaceL),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 18.sp(context))),
          SizedBox(height: context.layout.spaceM),
          content,
        ],
      ),
    );
  }
}
```

---

## 🧪 Testing Responsive Design

### Unit Tests for Responsive Logic

```dart
// test/responsive_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/responsive/responsive.dart';

void main() {
  group('Responsive System', () {
    test('device classification works correctly', () {
      expect(getDeviceSize(400.0), DeviceSize.phone);
      expect(getDeviceSize(800.0), DeviceSize.tablet);
      expect(getDeviceSize(1200.0), DeviceSize.desktop);
    });
    
    test('breakpoint calculation works correctly', () {
      expect(getBreakpoint(350.0), AppBreakpoint.compact);
      expect(getBreakpoint(500.0), AppBreakpoint.mobile);
      expect(getBreakpoint(800.0), AppBreakpoint.tablet);
      expect(getBreakpoint(1300.0), AppBreakpoint.desktop);
    });
  });
}
```

### Widget Tests for Responsive Components

```dart
// test/responsive_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/responsive/responsive.dart';

void main() {
  group('Responsive Widget Tests', () {
    testWidgets('renders phone layout on small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Responsive.builder(
            child: ResponsiveDashboard(),
          ),
        ),
      );
      
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
    
    testWidgets('renders tablet layout on medium screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Responsive.builder(
            child: ResponsiveDashboard(),
          ),
        ),
      );
      
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(Sidebar), findsOneWidget);
    });
  });
}
```

### Integration Tests

```dart
// integration_test/responsive_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pocketa/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Responsive Integration Tests', () {
    testWidgets('app adapts to different screen sizes', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Test phone layout
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Test tablet layout
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsNothing);
      
      // Test desktop layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpAndSettle();
      expect(find.byType(Sidebar), findsOneWidget);
    });
  });
}
```

---

## 🔄 Migration Guide

### From Hardcoded Values to Responsive System

```dart
// Before - Hardcoded values
Container(
  width: 200.0,
  height: 100.0,
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Content',
    style: TextStyle(fontSize: 18.0),
  ),
);

// After - Responsive system
Container(
  width: context.layout.responsiveSize(
    phone: 200.0,
    tablet: 250.0,
    desktop: 300.0,
  ),
  height: 100.rem(context),
  padding: EdgeInsets.all(context.layout.spaceL),
  child: Text(
    'Content',
    style: TextStyle(fontSize: 18.sp(context)),
  ),
);
```

### From MediaQuery to Responsive Context

```dart
// Before - Direct MediaQuery usage
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isTablet = screenWidth >= 600;
  
  return isTablet ? TabletLayout() : PhoneLayout();
}

// After - Responsive context
Widget build(BuildContext context) {
  final device = context.device;
  
  return switch (device) {
    DeviceSize.phone => PhoneLayout(),
    DeviceSize.tablet => TabletLayout(),
    DeviceSize.desktop => DesktopLayout(),
  };
}
```

### From Custom Breakpoints to Standard System

```dart
// Before - Custom breakpoint logic
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final isMobile = width < 600;
  final isTablet = width >= 600 && width < 1024;
  final isDesktop = width >= 1024;
  
  return Column(
    children: [
      if (isMobile) MobileHeader(),
      if (isTablet) TabletHeader(),
      if (isDesktop) DesktopHeader(),
    ],
  );
}

// After - Standard responsive system
Widget build(BuildContext context) {
  final breakpoint = context.layout.breakpoint;
  
  return Column(
    children: [
      if (breakpoint == AppBreakpoint.mobile) MobileHeader(),
      if (breakpoint == AppBreakpoint.tablet) TabletHeader(),
      if (breakpoint == AppBreakpoint.desktop) DesktopHeader(),
    ],
  );
}
```

---

## 📦 Reusable Package Setup

### Package Structure

```
pocketa_responsive/
├── lib/
│   ├── responsive.dart              # Main export
│   ├── responsive_widget.dart      # Responsive wrapper widget
│   ├── breakpoints.dart            # Breakpoint definitions
│   ├── device_detection.dart       # Device detection utilities
│   ├── scaling.dart                # Scaling system
│   ├── layout_utils.dart           # Layout utilities
│   └── extensions/
│       ├── context_extensions.dart
│       └── numeric_extensions.dart
├── test/
│   ├── responsive_test.dart
│   ├── breakpoints_test.dart
│   └── scaling_test.dart
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
└── README.md
```

### Package pubspec.yaml

```yaml
name: pocketa_responsive
description: Advanced responsive design system for Flutter applications
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

### Usage in Other Projects

```dart
// pubspec.yaml
dependencies:
  pocketa_responsive:
    git:
      url: https://github.com/your-org/pocketa_responsive.git
      ref: main

// In your app
import 'package:pocketa_responsive/responsive.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => Responsive.builder(
        child: child ?? const SizedBox(),
      ),
      home: MyHomePage(),
    );
  }
}

// In your widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final device = context.device;
    final layout = context.layout;
    
    return Container(
      padding: layout.insetsAll(2),
      child: Text(
        'Responsive Text',
        style: TextStyle(fontSize: 16.sp(context)),
      ),
    );
  }
}
```

---

## 🎨 Advanced Usage Patterns

### Responsive Grid System

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minTileWidth;
  final double aspectRatio;
  
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minTileWidth = 200.0,
    this.aspectRatio = 1.0,
  });
  
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final columns = layout.columnsFor(minTileWidth);
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: layout.spaceM,
        mainAxisSpacing: layout.spaceM,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

### Responsive Navigation

```dart
class ResponsiveNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final device = context.device;
    
    return switch (device) {
      DeviceSize.phone => BottomNavigationBar(
        items: _buildBottomNavItems(),
        onTap: _onBottomNavTap,
      ),
      DeviceSize.tablet => NavigationRail(
        destinations: _buildRailDestinations(),
        onDestinationSelected: _onRailDestinationSelected,
      ),
      DeviceSize.desktop => NavigationDrawer(
        child: ListView(
          children: _buildDrawerItems(),
        ),
      ),
    };
  }
}
```

### Responsive Typography

```dart
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });
  
  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final responsiveStyle = style?.copyWith(
      fontSize: style?.fontSize != null 
        ? style!.fontSize! * layout.textScale 
        : null,
    );
    
    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
    );
  }
}
```

---

This comprehensive responsive system guide provides everything needed to implement, maintain, and extend responsive design across multiple projects. The system is designed to be performant, flexible, and easy to use while providing powerful responsive capabilities.
