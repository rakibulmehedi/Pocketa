/// Comprehensive design system for PocketA
/// 
/// This module provides a complete design system with:
/// - Design tokens for spacing, typography, colors, etc.
/// - Color system with semantic tokens
/// - Typography system with responsive text styles
/// - Component system with consistent UI patterns
/// 
/// Usage:
/// ```dart
/// import 'package:pocketa/core/design_system/design_system.dart';
/// 
/// // Use design tokens
/// SizedBox(height: DesignTokens.spaceL);
/// 
/// // Use color tokens
/// Container(color: ColorTokens.primary(context));
/// 
/// // Use typography tokens
/// Text('Hello', style: TypographyTokens.headlineLarge(context));
/// 
/// // Use component tokens
/// ElevatedButton(
///   style: ComponentTokens.primaryButton(context),
///   onPressed: () {},
///   child: Text('Button'),
/// );
/// ```

export 'design_tokens.dart';
export 'color_tokens.dart';
export 'typography_tokens.dart';
export 'component_tokens.dart';
