import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';

class SeedMotivationScreen extends ConsumerStatefulWidget {
  const SeedMotivationScreen({super.key});

  @override
  ConsumerState<SeedMotivationScreen> createState() => _SeedMotivationScreenState();
}

class _SeedMotivationScreenState extends ConsumerState<SeedMotivationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _plantController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _plantGrowthAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _plantController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _plantGrowthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _plantController,
        curve: Curves.elasticOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _plantController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _plantController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: layout.pageGutter,
              child: Column(
                children: [
                  // Animated Header
                  AnimatedBuilder(
                    animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value.dy * 50),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                'আজই প্রথম বীজ বপন করুন',
                                style: layout.responsiveTextStyle(
                                  phone: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                  tablet: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                  desktop: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: layout.spaceL),
                              Text(
                                'একটি ছোট খরচ যোগ করে শুরু করুন',
                                style: layout.responsiveTextStyle(
                                  phone: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                  tablet: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                  desktop: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: layout.space2xl),

                  // Animated Plant Growth
                  AnimatedBuilder(
                    animation: Listenable.merge([_plantGrowthAnimation, _pulseAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          height: layout.responsiveSize(phone: 300, tablet: 350, desktop: 400),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(layout.radiusXl),
                          ),
                          child: Stack(
                            children: [
                              // Ground
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.warning(context).withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(layout.radiusXl),
                                      bottomRight: Radius.circular(layout.radiusXl),
                                    ),
                                  ),
                                ),
                              ),
                              // Growing Plant
                              Positioned(
                                bottom: 60,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: _plantGrowthAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _plantGrowthAnimation.value,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Plant stem
                                            Container(
                                              width: 8,
                                              height: 80 * _plantGrowthAnimation.value,
                                              decoration: BoxDecoration(
                                                color: AppColors.success(context),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            // Plant leaves
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                _buildLeaf(AppColors.success(context).withValues(alpha: 0.8), 20, layout),
                                                SizedBox(width: 8),
                                                _buildLeaf(AppColors.success(context), 24, layout),
                                                SizedBox(width: 8),
                                                _buildLeaf(AppColors.success(context).withValues(alpha: 0.8), 20, layout),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Progress indicator
                              Positioned(
                                top: layout.spaceL,
                                left: layout.spaceL,
                                right: layout.spaceL,
                                child: Container(
                                  padding: EdgeInsets.all(layout.spaceM),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(layout.radiusM),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Progress',
                                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                        ),
                                      ),
                                      SizedBox(height: layout.spaceS),
                                      LinearProgressIndicator(
                                        value: _plantGrowthAnimation.value,
                                        backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: layout.space2xl),

                  // Motivational message
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(layout.spaceL),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(layout.radiusL),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                                size: layout.responsiveIconSize(phone: 32, tablet: 36, desktop: 40),
                              ),
                              SizedBox(height: layout.spaceM),
                              Text(
                                'প্রতিদিন ১০ সেকেন্ড—স্ট্রিক বজায় রাখুন, স্বপ্নে বিনিয়োগ করুন',
                                style: layout.responsiveTextStyle(
                                  phone: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                  tablet: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                  desktop: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaf(Color color, double size, AppSize layout) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
