import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class CustomSnackbar extends StatefulWidget {
  final String message;
  final SnackbarType type;
  final Duration duration;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData? icon;
  final bool showCloseButton;

  const CustomSnackbar({
    super.key,
    required this.message,
    this.type = SnackbarType.info,
    this.duration = const Duration(seconds: 3),
    this.onAction,
    this.actionLabel,
    this.icon,
    this.showCloseButton = true,
  });

  @override
  State<CustomSnackbar> createState() => _CustomSnackbarState();
}

class _CustomSnackbarState extends State<CustomSnackbar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
    _fadeController.forward();

    // Auto-dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _fadeController.reverse();
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    final colors = _getColors(theme);
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: layout.pageGutter.horizontal,
            vertical: layout.spaceS,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(layout.radiusL),
            border: Border.all(
              color: colors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(layout.radiusL),
              onTap: widget.onAction,
              child: Padding(
                padding: EdgeInsets.all(layout.spaceM),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 40.ic(context),
                      height: 40.ic(context),
                      decoration: BoxDecoration(
                        color: colors.iconBackground,
                        borderRadius: BorderRadius.circular(20.ic(context)),
                      ),
                      child: Icon(
                        widget.icon ?? _getDefaultIcon(),
                        color: colors.icon,
                        size: 20.ic(context),
                      ),
                    ),
                    
                    SizedBox(width: layout.spaceM),
                    
                    // Message
                    Expanded(
                      child: Text(
                        widget.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                    
                    // Action button
                    if (widget.onAction != null && widget.actionLabel != null)
                      Padding(
                        padding: EdgeInsets.only(left: layout.spaceS),
                        child: TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            widget.onAction!();
                            _dismiss();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: colors.actionText,
                            padding: EdgeInsets.symmetric(
                              horizontal: layout.spaceM,
                              vertical: layout.spaceXs,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            widget.actionLabel!,
                            style: TextStyle(
                              fontSize: layout.tSm,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    
                    // Close button
                    if (widget.showCloseButton)
                      Padding(
                        padding: EdgeInsets.only(left: layout.spaceXs),
                        child: IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _dismiss();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 18.ic(context),
                            color: colors.closeIcon,
                          ),
                          style: IconButton.styleFrom(
                            minimumSize: Size(32.ic(context), 32.ic(context)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getDefaultIcon() {
    switch (widget.type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_outlined;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }

  _SnackbarColors _getColors(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    switch (widget.type) {
      case SnackbarType.success:
        return _SnackbarColors(
          background: isDark ? const Color(0xFF1B5E20) : const Color(0xFFE8F5E8),
          text: isDark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32),
          icon: isDark ? const Color(0xFF4CAF50) : const Color(0xFF388E3C),
          iconBackground: isDark ? const Color(0xFF2E7D32) : const Color(0xFFC8E6C9),
          border: isDark ? const Color(0xFF2E7D32) : const Color(0xFF4CAF50),
          actionText: isDark ? const Color(0xFF81C784) : const Color(0xFF1B5E20),
          closeIcon: isDark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32),
          shadow: isDark ? Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.1),
        );
        
      case SnackbarType.error:
        return _SnackbarColors(
          background: isDark ? const Color(0xFF5D1A1A) : const Color(0xFFFFEBEE),
          text: isDark ? const Color(0xFFFFCDD2) : const Color(0xFFD32F2F),
          icon: isDark ? const Color(0xFFF44336) : const Color(0xFFE53935),
          iconBackground: isDark ? const Color(0xFFB71C1C) : const Color(0xFFFFCDD2),
          border: isDark ? const Color(0xFFB71C1C) : const Color(0xFFF44336),
          actionText: isDark ? const Color(0xFFFFAB91) : const Color(0xFFB71C1C),
          closeIcon: isDark ? const Color(0xFFFFCDD2) : const Color(0xFFD32F2F),
          shadow: isDark ? Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.1),
        );
        
      case SnackbarType.warning:
        return _SnackbarColors(
          background: isDark ? const Color(0xFF5D4E1A) : const Color(0xFFFFF8E1),
          text: isDark ? const Color(0xFFFFF176) : const Color(0xFFF57C00),
          icon: isDark ? const Color(0xFFFFC107) : const Color(0xFFFF9800),
          iconBackground: isDark ? const Color(0xFFB71C1C) : const Color(0xFFFFF176),
          border: isDark ? const Color(0xFFB71C1C) : const Color(0xFFFFC107),
          actionText: isDark ? const Color(0xFFFFF176) : const Color(0xFFE65100),
          closeIcon: isDark ? const Color(0xFFFFF176) : const Color(0xFFF57C00),
          shadow: isDark ? Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.1),
        );
        
      case SnackbarType.info:
        return _SnackbarColors(
          background: isDark ? const Color(0xFF1A237E) : const Color(0xFFE3F2FD),
          text: isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2),
          icon: isDark ? const Color(0xFF2196F3) : const Color(0xFF1976D2),
          iconBackground: isDark ? const Color(0xFF283593) : const Color(0xFFBBDEFB),
          border: isDark ? const Color(0xFF283593) : const Color(0xFF2196F3),
          actionText: isDark ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1),
          closeIcon: isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2),
          shadow: isDark ? Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.1),
        );
    }
  }
}

class _SnackbarColors {
  final Color background;
  final Color text;
  final Color icon;
  final Color iconBackground;
  final Color border;
  final Color actionText;
  final Color closeIcon;
  final Color shadow;

  const _SnackbarColors({
    required this.background,
    required this.text,
    required this.icon,
    required this.iconBackground,
    required this.border,
    required this.actionText,
    required this.closeIcon,
    required this.shadow,
  });
}
