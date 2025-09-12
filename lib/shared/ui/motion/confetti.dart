import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pocketa/shared/ui/motion/motion.dart';

/// Lightweight confetti system with accessibility support
class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool showConfetti;
  final Duration duration;
  final int particleCount;
  final List<Color> colors;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.showConfetti = false,
    this.duration = const Duration(milliseconds: 600),
    this.particleCount = 20,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ],
  });

  /// Show confetti overlay
  static void show(BuildContext context, {
    Duration duration = const Duration(milliseconds: 600),
    int particleCount = 20,
    List<Color>? colors,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => ConfettiOverlay(
        showConfetti: true,
        duration: duration,
        particleCount: particleCount,
        colors: colors ?? const [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
        ],
        child: const SizedBox.shrink(),
      ),
    );

    overlay.insert(entry);

    // Remove after animation completes
    Future.delayed(duration, () {
      entry.remove();
    });
  }

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
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

    if (widget.showConfetti) {
      _generateParticles();
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showConfetti && !oldWidget.showConfetti) {
      _generateParticles();
      _controller.forward();
    }
  }

  void _generateParticles() {
    particles.clear();
    final random = math.Random();
    
    for (int i = 0; i < widget.particleCount; i++) {
      particles.add(ConfettiParticle(
        color: widget.colors[random.nextInt(widget.colors.length)],
        startX: random.nextDouble(),
        startY: random.nextDouble() * 0.5, // Start from top half
        velocityX: (random.nextDouble() - 0.5) * 2.0,
        velocityY: random.nextDouble() * 2.0 + 1.0,
        rotation: random.nextDouble() * 2 * math.pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 4.0,
        size: random.nextDouble() * 8.0 + 4.0,
        gravity: 0.5 + random.nextDouble() * 0.5,
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
    // Respect reduced motion preference
    if (Motion.isReduced(context)) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (widget.showConfetti)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(
                  particles: particles,
                  progress: _controller.value,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),
      ],
    );
  }
}

/// Individual confetti particle
class ConfettiParticle {
  final Color color;
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
  final double size;
  final double gravity;

  ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.gravity,
  });

  /// Calculate particle position at given progress (0.0 to 1.0)
  Offset getPosition(double progress) {
    final time = progress * 2.0; // Slow down the animation
    final x = startX + velocityX * time;
    final y = startY + velocityY * time + 0.5 * gravity * time * time;
    return Offset(x, y);
  }

  /// Calculate particle rotation at given progress
  double getRotation(double progress) {
    return rotation + rotationSpeed * progress;
  }

  /// Calculate particle opacity (fade out over time)
  double getOpacity(double progress) {
    return math.max(0.0, 1.0 - progress * 1.5);
  }
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
    for (final particle in particles) {
      final position = particle.getPosition(progress);
      final rotation = particle.getRotation(progress);
      final opacity = particle.getOpacity(progress);

      // Skip if particle is off-screen or fully transparent
      if (opacity <= 0.0 || 
          position.dx < -50 || 
          position.dx > size.width + 50 ||
          position.dy > size.height + 50) {
        continue;
      }

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(position.dx * size.width, position.dy * size.height);
      canvas.rotate(rotation);

      // Draw confetti shape (small rectangle)
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        const Radius.circular(2),
      );
      canvas.drawRRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

/// Simple confetti burst animation
class ConfettiBurst extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final Duration duration;
  final int particleCount;
  final List<Color> colors;

  const ConfettiBurst({
    super.key,
    required this.child,
    this.trigger = false,
    this.duration = const Duration(milliseconds: 600),
    this.particleCount = 20,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ],
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger && !_hasTriggered) {
      _hasTriggered = true;
      _controller.forward().then((_) {
        if (mounted) {
          _controller.reset();
          _hasTriggered = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      showConfetti: _animation.value > 0,
      duration: widget.duration,
      particleCount: widget.particleCount,
      colors: widget.colors,
      child: widget.child,
    );
  }
}