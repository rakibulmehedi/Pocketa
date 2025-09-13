/// Feature flags for controlling app features
/// 
/// These flags allow for safe feature rollouts and easy rollbacks
class FeatureFlags {
  /// Enable the new Confetti V2 system with premium styles and physics
  static const bool kEnableCelebrationV2 = true;
  
  /// Enable celebration sounds (if sound service is available)
  static const bool kEnableCelebrationSounds = true;
  
  /// Enable haptic feedback for celebrations
  static const bool kEnableCelebrationHaptics = true;
  
  /// Enable confetti effects (can be disabled for performance)
  static const bool kEnableCelebrationConfetti = true;
}
