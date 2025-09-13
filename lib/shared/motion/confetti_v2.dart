import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/feature_flags.dart';
import 'package:pocketa/shared/ui/motion.dart';

/// Confetti styles for different celebration types
enum ConfettiStyle {
  achievement,
  celebration,
  reward,
  milestone,
  victory,
}

/// Premium confetti overlay with multiple styles and physics
class ConfettiOverlay extends StatefulWidget {
  final ConfettiStyle style;
  final VoidCallback? onComplete;

  const ConfettiOverlay({
    super.key,
    required this.style,
    this.onComplete,
  });

  /// Show confetti overlay with specified style
  static Future<void> show(
    BuildContext context, {
    ConfettiStyle style = ConfettiStyle.achievement,
    VoidCallback? onComplete,
  }) async {
    if (!FeatureFlags.kEnableCelebrationConfetti) return;
    
    // Check for reduced motion
    if (Motion.isReduced(context)) {
      onComplete?.call();
      return;
    }

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => ConfettiOverlay(
        style: style,
        onComplete: () {
          entry.remove();
          onComplete?.call();
        },
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateParticles();
  }

  void _initializeAnimation() {
    final config = _getStyleConfig();
    _controller = AnimationController(
      duration: config.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: config.curve),
    );
  }

  void _generateParticles() {
    final config = _getStyleConfig();
    
    // Adjust particle count based on screen size and reduced motion
    final isReduced = Motion.isReduced(context);
    final particleCount = isReduced 
        ? math.min(config.particleCount, 16)
        : config.particleCount;

    _particles.clear();
    for (int i = 0; i < particleCount; i++) {
      _particles.add(_createParticle(config, null));
    }
  }

  ConfettiParticle _createParticle(ConfettiStyleConfig config, dynamic layout) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return ConfettiParticle(
      x: _random.nextDouble() * screenWidth,
      y: -50.0, // Start above screen
      vx: (_random.nextDouble() - 0.5) * config.horizontalSpread,
      vy: _random.nextDouble() * config.verticalVelocity + config.minVerticalVelocity,
      color: _getRandomColor(),
      size: _random.nextDouble() * config.maxSize + config.minSize,
      rotation: _random.nextDouble() * 2 * math.pi,
      rotationSpeed: (_random.nextDouble() - 0.5) * config.rotationSpeed,
      shape: _getRandomShape(),
      gravity: config.gravity,
      drag: config.drag,
    );
  }

  Color _getRandomColor() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Use theme colors for better integration
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];
    
    return colors[_random.nextInt(colors.length)];
  }

  ConfettiShape _getRandomShape() {
    final shapes = ConfettiShape.values;
    return shapes[_random.nextInt(shapes.length)];
  }

  ConfettiStyleConfig _getStyleConfig() {
    return switch (widget.style) {
      ConfettiStyle.achievement => ConfettiStyleConfig(
        duration: const Duration(milliseconds: 2000),
        particleCount: 40,
        curve: Curves.easeOut,
        horizontalSpread: 200.0,
        verticalVelocity: 300.0,
        minVerticalVelocity: 100.0,
        minSize: 4.0,
        maxSize: 8.0,
        rotationSpeed: 0.1,
        gravity: 0.3,
        drag: 0.02,
      ),
      ConfettiStyle.celebration => ConfettiStyleConfig(
        duration: const Duration(milliseconds: 2500),
        particleCount: 60,
        curve: Curves.easeOut,
        horizontalSpread: 300.0,
        verticalVelocity: 400.0,
        minVerticalVelocity: 150.0,
        minSize: 3.0,
        maxSize: 10.0,
        rotationSpeed: 0.15,
        gravity: 0.25,
        drag: 0.015,
      ),
      ConfettiStyle.reward => ConfettiStyleConfig(
        duration: const Duration(milliseconds: 1800),
        particleCount: 35,
        curve: Curves.easeOut,
        horizontalSpread: 180.0,
        verticalVelocity: 250.0,
        minVerticalVelocity: 80.0,
        minSize: 5.0,
        maxSize: 9.0,
        rotationSpeed: 0.08,
        gravity: 0.35,
        drag: 0.025,
      ),
      ConfettiStyle.milestone => ConfettiStyleConfig(
        duration: const Duration(milliseconds: 3000),
        particleCount: 80,
        curve: Curves.easeOut,
        horizontalSpread: 400.0,
        verticalVelocity: 500.0,
        minVerticalVelocity: 200.0,
        minSize: 4.0,
        maxSize: 12.0,
        rotationSpeed: 0.12,
        gravity: 0.2,
        drag: 0.01,
      ),
      ConfettiStyle.victory => ConfettiStyleConfig(
        duration: const Duration(milliseconds: 3500),
        particleCount: 100,
        curve: Curves.easeOut,
        horizontalSpread: 500.0,
        verticalVelocity: 600.0,
        minVerticalVelocity: 250.0,
        minSize: 3.0,
        maxSize: 15.0,
        rotationSpeed: 0.18,
        gravity: 0.15,
        drag: 0.008,
      ),
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: ConfettiPainter(
                particles: _particles,
                progress: _animation.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

/// Configuration for different confetti styles
class ConfettiStyleConfig {
  final Duration duration;
  final int particleCount;
  final Curve curve;
  final double horizontalSpread;
  final double verticalVelocity;
  final double minVerticalVelocity;
  final double minSize;
  final double maxSize;
  final double rotationSpeed;
  final double gravity;
  final double drag;

  const ConfettiStyleConfig({
    required this.duration,
    required this.particleCount,
    required this.curve,
    required this.horizontalSpread,
    required this.verticalVelocity,
    required this.minVerticalVelocity,
    required this.minSize,
    required this.maxSize,
    required this.rotationSpeed,
    required this.gravity,
    required this.drag,
  });
}

/// Confetti particle with physics
class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;
  ConfettiShape shape;
  double gravity;
  double drag;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
    required this.gravity,
    required this.drag,
  });

  void update(double deltaTime) {
    // Apply gravity
    vy += gravity * deltaTime;
    
    // Apply drag
    vx *= (1 - drag);
    vy *= (1 - drag);
    
    // Update position
    x += vx * deltaTime;
    y += vy * deltaTime;
    
    // Update rotation
    rotation += rotationSpeed * deltaTime;
  }
}

/// Available confetti shapes
enum ConfettiShape {
  rectangle,
  circle,
  star,
  diamond,
  triangle,
  hexagon,
  heart,
}

/// Custom painter for confetti particles
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final deltaTime = 16.0; // Approximate 60fps
    
    for (final particle in particles) {
      // Update particle physics
      particle.update(deltaTime);
      
      // Calculate opacity based on progress and position
      final opacity = _calculateOpacity(particle, size);
      if (opacity <= 0) continue;
      
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      // Draw shape based on particle type
      _drawShape(canvas, particle, paint);

      canvas.restore();
    }
  }

  double _calculateOpacity(ConfettiParticle particle, Size size) {
    // Fade out based on progress
    final progressFade = 1.0 - progress;
    
    // Fade out when particle goes off screen
    final screenFade = math.max(0.0, 1.0 - (particle.y / size.height));
    
    return progressFade * screenFade;
  }

  void _drawShape(Canvas canvas, ConfettiParticle particle, Paint paint) {
    final halfSize = particle.size / 2;
    
    switch (particle.shape) {
      case ConfettiShape.rectangle:
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 0.6,
          ),
          paint,
        );
        break;
        
      case ConfettiShape.circle:
        canvas.drawCircle(Offset.zero, halfSize, paint);
        break;
        
      case ConfettiShape.star:
        _drawStar(canvas, Offset.zero, halfSize, paint);
        break;
        
      case ConfettiShape.diamond:
        _drawDiamond(canvas, Offset.zero, halfSize, paint);
        break;
        
      case ConfettiShape.triangle:
        _drawTriangle(canvas, Offset.zero, halfSize, paint);
        break;
        
      case ConfettiShape.hexagon:
        _drawHexagon(canvas, Offset.zero, halfSize, paint);
        break;
        
      case ConfettiShape.heart:
        _drawHeart(canvas, Offset.zero, halfSize, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final outerRadius = radius;
    final innerRadius = radius * 0.4;
    
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi) / 5;
      final r = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + r * math.cos(angle - math.pi / 2);
      final y = center.dy + r * math.sin(angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius * 0.866, center.dy + radius * 0.5);
    path.lineTo(center.dx - radius * 0.866, center.dy + radius * 0.5);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    final x = center.dx;
    final y = center.dy;
    final w = radius;
    
    path.moveTo(x, y + w * 0.3);
    path.cubicTo(x, y, x - w * 0.5, y, x - w * 0.5, y + w * 0.3);
    path.cubicTo(x - w * 0.5, y + w * 0.6, x, y + w * 0.6, x, y + w);
    path.cubicTo(x, y + w * 0.6, x + w * 0.5, y + w * 0.6, x + w * 0.5, y + w * 0.3);
    path.cubicTo(x + w * 0.5, y, x, y, x, y + w * 0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Helper function to trigger celebrations
Future<void> celebrate(
  BuildContext context, {
  ConfettiStyle style = ConfettiStyle.achievement,
  VoidCallback? onComplete,
}) async {
  if (!FeatureFlags.kEnableCelebrationV2) return;
  
  // Add haptic feedback if enabled
  if (FeatureFlags.kEnableCelebrationHaptics) {
    switch (style) {
      case ConfettiStyle.achievement:
        HapticFeedback.lightImpact();
        break;
      case ConfettiStyle.celebration:
        HapticFeedback.mediumImpact();
        break;
      case ConfettiStyle.reward:
        HapticFeedback.lightImpact();
        break;
      case ConfettiStyle.milestone:
        HapticFeedback.heavyImpact();
        break;
      case ConfettiStyle.victory:
        HapticFeedback.heavyImpact();
        break;
    }
  }
  
  await ConfettiOverlay.show(
    context,
    style: style,
    onComplete: onComplete,
  );
}
