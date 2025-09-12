import 'package:flutter/material.dart';

// Re-export the unified motion system
export 'motion/motion.dart';
export 'motion/confetti.dart';

// Legacy compatibility - keep AppMotion for existing code
class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const med  = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 320);
  static const ease  = Curves.easeOutCubic;
  static const easeIn = Curves.easeInCubic;
  static const spring = Curves.easeOutBack;
}
