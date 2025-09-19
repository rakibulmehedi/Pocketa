import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';

/// Button styles for different use cases
enum InteractiveButtonStyle { 
  primary, 
  secondary, 
  outline, 
  text, 
  success, 
  warning, 
  error,
  ghost 
}

/// Button sizes for different contexts
enum InteractiveButtonSize { 
  small, 
  medium, 
  large, 
  extraLarge 
}

/// Haptic feedback types
enum HapticType { 
  light, 
  medium, 
  heavy, 
  selection, 
  none 
}

/// A comprehensive interactive button with advanced animations, haptic feedback, and multiple styles
class InteractiveButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final bool enableHaptic;
  final bool enableSound;
  final HapticType hapticType;
  final Duration animationDuration;
  final Curve animationCurve;
  final InteractiveButtonStyle style;
  final InteractiveButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final bool isSelected;
  final bool isDisabled;
  final String? tooltip;
  final String? semanticLabel;
  final bool enableRipple;
  final Gradient? gradient;
  final bool enableGlow;
  final double glowRadius;
  final Color? glowColor;
  final bool enableBounce;
  final double bounceScale;
  final Duration bounceDuration;
  final bool enableShimmer;
  final Color? shimmerColor;
  final Duration shimmerDuration;
  final bool enablePulse;
  final Duration pulseDuration;
  final double pulseScale;
  final bool enableSplash;
  final Color? splashColor;
  final double? width;
  final double? height;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final TextOverflow textOverflow;
  final int? maxLines;
  final bool enableFocus;
  final FocusNode? focusNode;
  final bool autofocus;
  final VoidCallback? onFocusChange;
  final VoidCallback? onLongPress;
  final Duration longPressDelay;
  final bool enableKeyboard;
  final String? keyboardShortcut;
  final bool enableAccessibility;
  final String? accessibilityHint;
  final bool enableContextMenu;
  final List<PopupMenuEntry<String>>? contextMenuItems;

  const InteractiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
    this.enableSound = false,
    this.hapticType = HapticType.light,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.style = InteractiveButtonStyle.primary,
    this.size = InteractiveButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.elevation,
    this.boxShadow,
    this.border,
    this.isSelected = false,
    this.isDisabled = false,
    this.tooltip,
    this.semanticLabel,
    this.enableRipple = true,
    this.gradient,
    this.enableGlow = false,
    this.glowRadius = 8.0,
    this.glowColor,
    this.enableBounce = false,
    this.bounceScale = 1.05,
    this.bounceDuration = const Duration(milliseconds: 100),
    this.enableShimmer = false,
    this.shimmerColor,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.enablePulse = false,
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.pulseScale = 1.02,
    this.enableSplash = true,
    this.splashColor,
    this.width,
    this.height,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textOverflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    this.enableFocus = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onLongPress,
    this.longPressDelay = const Duration(milliseconds: 500),
    this.enableKeyboard = true,
    this.keyboardShortcut,
    this.enableAccessibility = true,
    this.accessibilityHint,
    this.enableContextMenu = false,
    this.contextMenuItems,
  });

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;

  bool _isFocused = false;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode!.addListener(_handleFocusChange);
    
    _initializeAnimations();
    _startContinuousAnimations();
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    }
    _animationController.dispose();
    _bounceController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: widget.bounceDuration,
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: widget.shimmerDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 2.0,
      end: (widget.elevation ?? 2.0) * 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: widget.bounceScale,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pulseScale,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startContinuousAnimations() {
    if (widget.enableShimmer) {
      _shimmerController.repeat();
    }
    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode!.hasFocus) {
      setState(() {
        _isFocused = _focusNode!.hasFocus;
      });
      widget.onFocusChange?.call();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    
    _animationController.forward();
    
    if (widget.enableBounce) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }
    
    _triggerHapticFeedback();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isDisabled || widget.isLoading) return;
    
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (widget.isDisabled || widget.isLoading) return;
    
    _animationController.reverse();
  }

  void _handleTap() {
    if (widget.isDisabled || widget.isLoading || widget.onPressed == null) return;
    
    widget.onPressed!();
  }

  void _handleLongPress() {
    if (widget.isDisabled || widget.isLoading || widget.onLongPress == null) return;
    
    _triggerHapticFeedback(HapticType.heavy);
    widget.onLongPress!();
  }

  void _triggerHapticFeedback([HapticType? type]) {
    if (!widget.enableHaptic) return;
    
    final hapticType = type ?? widget.hapticType;
    
    switch (hapticType) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.none:
        break;
    }
    
    if (widget.enableSound) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    final isDisabled = widget.isDisabled || widget.isLoading || widget.onPressed == null;
    final buttonStyle = _getButtonStyle(context, theme, layout);
    
    _colorAnimation = ColorTween(
      begin: buttonStyle.backgroundColor,
      end: isDisabled 
          ? buttonStyle.backgroundColor.withValues(alpha: 0.5)
          : buttonStyle.backgroundColor.withValues(alpha: 0.8),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    Widget button = _buildButton(context, theme, layout, buttonStyle, isDisabled);

    if (widget.isFullWidth || widget.width != null) {
      button = SizedBox(
        width: widget.width ?? (widget.isFullWidth ? double.infinity : null),
        height: widget.height,
        child: button,
      );
    }

    if (widget.tooltip != null && !isDisabled) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    if (widget.enableAccessibility) {
      button = Semantics(
        label: widget.semanticLabel ?? widget.text,
        hint: widget.accessibilityHint,
        button: true,
        enabled: !isDisabled,
        child: button,
      );
    }

    if (widget.enableContextMenu && widget.contextMenuItems != null) {
      button = PopupMenuButton<String>(
        itemBuilder: (context) => widget.contextMenuItems!,
        child: button,
      );
    }

    return RepaintBoundary(child: button);
  }

  Widget _buildButton(
    BuildContext context,
    ThemeData theme,
    AppSize layout,
    _ButtonStyle buttonStyle,
    bool isDisabled,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _animationController,
        _bounceController,
        _shimmerController,
        _pulseController,
      ]),
      builder: (context, child) {
        final scale = _scaleAnimation.value * 
            (widget.enableBounce ? _bounceAnimation.value : 1.0) *
            (widget.enablePulse ? _pulseAnimation.value : 1.0);
        
        return Transform.scale(
          scale: scale,
          child: Focus(
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            onFocusChange: (hasFocus) {
              setState(() {
                _isFocused = hasFocus;
              });
            },
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: _handleTap,
              onLongPress: widget.onLongPress != null ? _handleLongPress : null,
              child: Container(
                padding: widget.padding ?? _getPadding(layout),
                margin: widget.margin,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _getBorderRadius(layout),
                  ),
                  border: widget.border ?? Border.all(
                    color: isDisabled 
                        ? theme.colorScheme.outline.withValues(alpha: 0.3)
                        : buttonStyle.borderColor,
                    width: widget.isSelected ? 2 : 1,
                  ),
                  boxShadow: _getBoxShadows(theme, isDisabled),
                ),
                child: _buildButtonContent(context, layout, buttonStyle.textColor, isDisabled),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonContent(
    BuildContext context,
    AppSize layout,
    Color textColor,
    bool isDisabled,
  ) {
    final theme = Theme.of(context);
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        if (widget.icon != null) ...[
          _buildIcon(layout, textColor, isDisabled),
          SizedBox(width: layout.spaceS),
        ],
        if (widget.isLoading)
          _buildLoadingIndicator(layout, textColor, isDisabled)
        else
          _buildText(theme, textColor, isDisabled),
        if (widget.trailingIcon != null) ...[
          SizedBox(width: layout.spaceS),
          _buildTrailingIcon(layout, textColor, isDisabled),
        ],
      ],
    );

    if (widget.enableShimmer) {
      content = _buildShimmerEffect(content, textColor);
    }

    if (widget.enableGlow && _isFocused) {
      content = _buildGlowEffect(content);
    }

    return content;
  }

  Widget _buildIcon(AppSize layout, Color textColor, bool isDisabled) {
    return Icon(
      widget.icon,
      size: _getIconSize(layout),
      color: isDisabled 
          ? textColor.withValues(alpha: 0.5)
          : textColor,
    );
  }

  Widget _buildTrailingIcon(AppSize layout, Color textColor, bool isDisabled) {
    return Icon(
      widget.trailingIcon,
      size: _getIconSize(layout),
      color: isDisabled 
          ? textColor.withValues(alpha: 0.5)
          : textColor,
    );
  }

  Widget _buildLoadingIndicator(AppSize layout, Color textColor, bool isDisabled) {
    return SizedBox(
      width: _getIconSize(layout),
      height: _getIconSize(layout),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          isDisabled 
              ? textColor.withValues(alpha: 0.5)
              : textColor,
        ),
      ),
    );
  }

  Widget _buildText(ThemeData theme, Color textColor, bool isDisabled) {
    return Text(
      widget.text,
      style: _getTextStyle(theme, textColor, isDisabled),
      textAlign: TextAlign.center,
      overflow: widget.textOverflow,
      maxLines: widget.maxLines,
    );
  }

  Widget _buildShimmerEffect(Widget child, Color textColor) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, shimmerChild) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                textColor.withValues(alpha: 0.3),
                textColor,
                textColor.withValues(alpha: 0.3),
              ],
              stops: [
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }

  Widget _buildGlowEffect(Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0),
        boxShadow: [
          BoxShadow(
            color: (widget.glowColor ?? Colors.blue).withValues(alpha: 0.5),
            blurRadius: widget.glowRadius,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  _ButtonStyle _getButtonStyle(BuildContext context, ThemeData theme, AppSize layout) {
    switch (widget.style) {
      case InteractiveButtonStyle.primary:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.primary(context),
          textColor: widget.textColor ?? AppColors.onPrimary(context),
          borderColor: widget.borderColor ?? AppColors.primary(context),
        );
      case InteractiveButtonStyle.secondary:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.success(context),
          textColor: widget.textColor ?? AppColors.onSuccess(context),
          borderColor: widget.borderColor ?? AppColors.success(context),
        );
      case InteractiveButtonStyle.outline:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.transparent,
          textColor: widget.textColor ?? AppColors.primary(context),
          borderColor: widget.borderColor ?? AppColors.primary(context),
        );
      case InteractiveButtonStyle.text:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.transparent,
          textColor: widget.textColor ?? AppColors.primary(context),
          borderColor: widget.borderColor ?? AppColors.transparent,
        );
      case InteractiveButtonStyle.success:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.success(context),
          textColor: widget.textColor ?? AppColors.onSuccess(context),
          borderColor: widget.borderColor ?? AppColors.success(context),
        );
      case InteractiveButtonStyle.warning:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.warning(context),
          textColor: widget.textColor ?? AppColors.onSurface(context),
          borderColor: widget.borderColor ?? AppColors.warning(context),
        );
      case InteractiveButtonStyle.error:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.error(context),
          textColor: widget.textColor ?? AppColors.onSurface(context),
          borderColor: widget.borderColor ?? AppColors.error(context),
        );
      case InteractiveButtonStyle.ghost:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.transparent,
          textColor: widget.textColor ?? AppColors.onSurface(context),
          borderColor: widget.borderColor ?? AppColors.transparent,
        );
    }
  }

  EdgeInsetsGeometry _getPadding(AppSize layout) {
    switch (widget.size) {
      case InteractiveButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: layout.spaceL,
          vertical: layout.spaceM,
        );
      case InteractiveButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: layout.spaceXL,
          vertical: layout.spaceL,
        );
      case InteractiveButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: layout.space2XL,
          vertical: layout.spaceXL,
        );
      case InteractiveButtonSize.extraLarge:
        return EdgeInsets.symmetric(
          horizontal: layout.space2XL * 1.5,
          vertical: layout.space2XL,
        );
    }
  }

  double _getBorderRadius(AppSize layout) {
    switch (widget.size) {
      case InteractiveButtonSize.small:
        return layout.radiusS;
      case InteractiveButtonSize.medium:
        return layout.radiusM;
      case InteractiveButtonSize.large:
        return layout.radiusL;
      case InteractiveButtonSize.extraLarge:
        return layout.radiusL * 1.2;
    }
  }

  double _getIconSize(AppSize layout) {
    switch (widget.size) {
      case InteractiveButtonSize.small:
        return layout.responsiveIconSize(phone: 14, tablet: 16, desktop: 18);
      case InteractiveButtonSize.medium:
        return layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20);
      case InteractiveButtonSize.large:
        return layout.responsiveIconSize(phone: 18, tablet: 20, desktop: 22);
      case InteractiveButtonSize.extraLarge:
        return layout.responsiveIconSize(phone: 20, tablet: 22, desktop: 24);
    }
  }

  TextStyle _getTextStyle(ThemeData theme, Color textColor, bool isDisabled) {
    final fontSize = _getFontSize();
    
    return theme.textTheme.labelLarge?.copyWith(
      fontSize: fontSize,
      color: isDisabled 
          ? textColor.withValues(alpha: 0.5)
          : textColor,
      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
      letterSpacing: 0.5,
    ) ?? TextStyle(
      fontSize: fontSize,
      color: isDisabled 
          ? textColor.withValues(alpha: 0.5)
          : textColor,
      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
      letterSpacing: 0.5,
    );
  }

  double _getFontSize() {
    switch (widget.size) {
      case InteractiveButtonSize.small:
        return 12;
      case InteractiveButtonSize.medium:
        return 14;
      case InteractiveButtonSize.large:
        return 16;
      case InteractiveButtonSize.extraLarge:
        return 18;
    }
  }

  List<BoxShadow> _getBoxShadows(ThemeData theme, bool isDisabled) {
    if (isDisabled) return [];
    
    final shadows = <BoxShadow>[];
    
    if (widget.boxShadow != null) {
      shadows.addAll(widget.boxShadow!);
    } else {
      shadows.add(
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: _elevationAnimation.value,
          offset: Offset(0, _elevationAnimation.value / 2),
        ),
      );
    }
    
    if (widget.enableGlow && _isFocused) {
      shadows.add(
        BoxShadow(
          color: (widget.glowColor ?? Colors.blue).withValues(alpha: 0.3),
          blurRadius: widget.glowRadius,
          spreadRadius: 1,
        ),
      );
    }
    
    return shadows;
  }
}

class _ButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}