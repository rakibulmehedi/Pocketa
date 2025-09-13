import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfettiWidget extends StatefulWidget {
  final bool isActive;
  final Duration duration;
  final Widget child;
  final int particleCount;
  final bool enableHapticFeedback;
  final bool enableSound;

  const ConfettiWidget({
    super.key,
    required this.isActive,
    required this.child,
    this.duration = const Duration(milliseconds: 3000),
    this.particleCount = 50,
    this.enableHapticFeedback = true,
    this.enableSound = true,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive && !_isAnimating) {
      _startConfetti();
    }
  }

  void _startConfetti() async {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
    });

    // Haptic feedback
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    // Sound feedback (you can add actual sound here)
    if (widget.enableSound) {
      // SystemSound.play(SystemSoundType.click);
    }

    _particles.clear();
    
    // Create more diverse and realistic confetti particles
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: -0.1 - _random.nextDouble() * 0.2, // Start above screen
        vx: (_random.nextDouble() - 0.5) * 0.8, // Wider spread
        vy: _random.nextDouble() * 0.3 + 0.1, // Slower initial fall
        color: _getRandomColor(),
        size: _random.nextDouble() * 6 + 3, // Larger particles
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.3, // More rotation
        shape: _getRandomShape(),
        gravity: 0.0008 + _random.nextDouble() * 0.0004, // Physics-based gravity
        wind: (_random.nextDouble() - 0.5) * 0.0002, // Slight wind effect
        bounce: 0.3 + _random.nextDouble() * 0.4, // Bounce factor
        life: 1.0,
        maxLife: 1.0,
      ));
    }
    
    await _controller.forward();
    
    setState(() {
      _isAnimating = false;
    });
  }

  Color _getRandomColor() {
    final colors = [
      Colors.red.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.yellow.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.pink.shade400,
      Colors.cyan.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  ConfettiShape _getRandomShape() {
    final shapes = [
      ConfettiShape.circle,
      ConfettiShape.square,
      ConfettiShape.triangle,
      ConfettiShape.star,
      ConfettiShape.heart,
    ];
    return shapes[_random.nextInt(shapes.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isActive)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([_animation, _scaleAnimation, _rotationAnimation]),
              builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(
                  particles: _particles,
                  progress: _animation.value,
                  scale: _scaleAnimation.value,
                  rotation: _rotationAnimation.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          ),
      ],
    );
  }
}

enum ConfettiShape {
  circle,
  square,
  triangle,
  star,
  heart,
}

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
  double wind;
  double bounce;
  double life;
  double maxLife;

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
    required this.wind,
    required this.bounce,
    required this.life,
    required this.maxLife,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;
  final double scale;
  final double rotation;
  int _lastFrameTime = 0;
  static const int _targetFPS = 60;
  static const int _frameDuration = 1000 ~/ _targetFPS;

  ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.scale,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Performance optimization: early exit if no particles
    if (particles.isEmpty) return;
    
    // Frame rate limiting for better performance
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastFrameTime < _frameDuration) return;
    _lastFrameTime = currentTime;
    
    // Pre-calculate common values
    final time = progress * 3.0; // Slow down time for more realistic movement
    final screenWidth = size.width;
    final screenHeight = size.height;
    
    for (final particle in particles) {
      // Calculate physics-based position
      final physicsY = particle.y + particle.vy * time + 0.5 * particle.gravity * time * time;
      final physicsX = particle.x + particle.vx * time + particle.wind * time * time;
      
      // Calculate alpha based on life and progress
      final lifeAlpha = particle.life / particle.maxLife;
      final progressAlpha = (1.0 - progress).clamp(0.0, 1.0);
      final alpha = lifeAlpha * progressAlpha;
      
      // Skip particles that are off-screen or have no alpha (performance optimization)
      if (physicsY > 1.2 || physicsY < -0.2 || physicsX < -0.2 || physicsX > 1.2 || alpha <= 0.0) continue;
      
      final paint = Paint()
        ..color = particle.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      
      // Apply physics-based transformation (use pre-calculated values)
      canvas.translate(
        physicsX * screenWidth,
        physicsY * screenHeight,
      );
      
      // Apply rotation with physics
      canvas.rotate(particle.rotation + particle.rotationSpeed * time * 2);
      
      // Apply scale animation
      canvas.scale(scale);

      // Draw different shapes based on particle type
      _drawShape(canvas, particle, paint);

      canvas.restore();

      // Update particle physics
      particle.vy += particle.gravity * 0.016; // 60fps physics
      particle.vx += particle.wind * 0.016;
      particle.rotation += particle.rotationSpeed * 0.016;
      
      // Reduce life over time
      particle.life -= 0.008; // Fade out over time
      
      // Apply bounce when hitting bottom
      if (physicsY > 1.0 && particle.vy > 0) {
        particle.vy *= -particle.bounce;
        particle.vx *= 0.8; // Reduce horizontal velocity on bounce
      }
    }
  }

  void _drawShape(Canvas canvas, ConfettiParticle particle, Paint paint) {
    final size = particle.size;
    final halfSize = size / 2;
    
    switch (particle.shape) {
      case ConfettiShape.circle:
        canvas.drawCircle(Offset.zero, halfSize, paint);
        break;
        
      case ConfettiShape.square:
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: size, height: size),
          paint,
        );
        break;
        
      case ConfettiShape.triangle:
        final path = Path();
        path.moveTo(0, -halfSize);
        path.lineTo(-halfSize, halfSize);
        path.lineTo(halfSize, halfSize);
        path.close();
        canvas.drawPath(path, paint);
        break;
        
      case ConfettiShape.star:
        _drawStar(canvas, Offset.zero, halfSize, paint);
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
      final angle = (i * pi / 5) - (pi / 2);
      final x = center.dx + (i.isEven ? outerRadius : innerRadius) * cos(angle);
      final y = center.dy + (i.isEven ? outerRadius : innerRadius) * sin(angle);
      
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
    final size = radius;
    
    path.moveTo(x, y + size * 0.3);
    path.cubicTo(x - size * 0.5, y - size * 0.3, x - size, y + size * 0.1, x, y + size);
    path.cubicTo(x + size, y + size * 0.1, x + size * 0.5, y - size * 0.3, x, y + size * 0.3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.scale != scale || 
           oldDelegate.rotation != rotation;
  }
}
