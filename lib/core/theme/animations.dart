import 'package:flutter/material.dart';

/// [Animation Constants] Standardized durations and curves for consistent animations.
///
/// Provides centralized animation configuration following Material Design guidelines
/// and optimized for 60 FPS performance.
///
/// Purpose: Ensure consistent animation behavior across the app
class AppAnimations {
  // Private constructor to prevent instantiation
  AppAnimations._();

  // Animation Durations
  /// [Duration] Very quick animations (100ms)
  ///
  /// Rationale: Immediate feedback for button presses
  /// Usage: Button press animations, ripple effects
  static const Duration veryQuick = Duration(milliseconds: 100);

  /// [Duration] Quick animations (200ms)
  ///
  /// Rationale: Snappy UI updates without feeling rushed
  /// Usage: Icon animations, small widget transitions
  static const Duration quick = Duration(milliseconds: 200);

  /// [Duration] Standard animations (300ms)
  ///
  /// Rationale: Material Design standard, feels natural
  /// Usage: Screen transitions, dialog animations
  static const Duration standard = Duration(milliseconds: 300);

  /// [Duration] Slow animations (500ms)
  ///
  /// Rationale: Draws attention to important state changes
  /// Usage: Important notifications, major state transitions
  static const Duration slow = Duration(milliseconds: 500);

  /// [Duration] Very slow animations (1000ms)
  ///
  /// Rationale: Allows users to fully appreciate the effect
  /// Usage: Celebration animations, point counter animations
  static const Duration verySlow = Duration(milliseconds: 1000);

  /// [Duration] Confetti celebration (2000ms)
  ///
  /// Rationale: Full celebration effect without overstaying
  /// Usage: Lesson completion, achievement unlock
  static const Duration confetti = Duration(milliseconds: 2000);

  /// [Duration] Fireworks celebration (3000ms)
  ///
  /// Rationale: Extended celebration for major achievements
  /// Usage: Level completion, major milestones
  static const Duration fireworks = Duration(milliseconds: 3000);

  // Animation Curves
  /// [Curve] Standard easing curve
  ///
  /// Rationale: Smooth acceleration and deceleration
  /// Usage: Most animations for natural movement
  static const Curve easeInOut = Curves.easeInOut;

  /// [Curve] Ease out curve
  ///
  /// Rationale: Fast start, gentle landing
  /// Usage: Elements entering the screen
  static const Curve easeOut = Curves.easeOut;

  /// [Curve] Ease in curve
  ///
  /// Rationale: Gentle start, fast finish
  /// Usage: Elements leaving the screen
  static const Curve easeIn = Curves.easeIn;

  /// [Curve] Bouncy curve for playful effects
  ///
  /// Rationale: Adds personality and energy
  /// Usage: Button animations, success indicators, achievements
  static const Curve bounceOut = Curves.bounceOut;

  /// [Curve] Elastic curve for spring-like effects
  ///
  /// Rationale: Energetic, attention-grabbing
  /// Usage: Celebration animations, special effects
  static const Curve elasticOut = Curves.elasticOut;

  /// [Curve] Fast out, slow in for Material Design
  ///
  /// Rationale: Material Design standard for page transitions
  /// Usage: Screen transitions, navigation
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Common Animation Combinations
  /// [Map] Button press animation configuration
  ///
  /// Combines quick duration with bounceOut curve for satisfying feedback
  static const Map<String, dynamic> buttonPress = {
    'duration': veryQuick,
    'curve': bounceOut,
  };

  /// [Map] Screen transition animation configuration
  ///
  /// Combines standard duration with fastOutSlowIn for smooth navigation
  static const Map<String, dynamic> screenTransition = {
    'duration': standard,
    'curve': fastOutSlowIn,
  };

  /// [Map] Success animation configuration
  ///
  /// Combines slow duration with elasticOut for celebratory feedback
  static const Map<String, dynamic> success = {
    'duration': slow,
    'curve': elasticOut,
  };

  /// [Map] Points counter animation configuration
  ///
  /// Combines verySlow duration with easeOut for satisfying count-up
  static const Map<String, dynamic> pointsCounter = {
    'duration': verySlow,
    'curve': easeOut,
  };

  // Physics-based Animations
  /// [SpringDescription] Spring physics for draggable elements
  ///
  /// Rationale: Natural-feeling drag interactions
  /// Usage: Matching exercises, drag-and-drop
  static const SpringDescription spring = SpringDescription(
    mass: 1.0,
    stiffness: 100.0,
    damping: 15.0,
  );

  /// [SpringDescription] Bouncy spring for celebratory effects
  ///
  /// Rationale: Exaggerated bounce for visual excitement
  /// Usage: Achievement popups, star ratings
  static const SpringDescription bouncySpring = SpringDescription(
    mass: 1.0,
    stiffness: 150.0,
    damping: 10.0,
  );

  // Particle Effect Settings
  /// [int] Number of confetti particles
  ///
  /// Rationale: Enough for visual impact without performance cost
  static const int confettiParticleCount = 50;

  /// [int] Number of firework particles
  ///
  /// Rationale: Dense effect for major celebrations
  static const int fireworkParticleCount = 100;

  /// [int] Number of star particles for achievements
  ///
  /// Rationale: Moderate count for achievement unlocks
  static const int starParticleCount = 20;

  // Rotation and Scaling
  /// [double] Standard rotation angle for shaking effect (radians)
  ///
  /// Rationale: 5 degrees provides noticeable shake without disorientation
  static const double standardShakeAngle = 0.0872665; // ~5 degrees

  /// [double] Standard scale up factor
  ///
  /// Rationale: 10% increase is noticeable without being jarring
  static const double standardScaleUp = 1.1;

  /// [double] Button press scale down factor
  ///
  /// Rationale: 5% decrease provides tactile feedback
  static const double buttonPressScale = 0.95;

  /// [double] Success celebration scale up factor
  ///
  /// Rationale: 20% increase creates excitement
  static const double celebrationScale = 1.2;
}
