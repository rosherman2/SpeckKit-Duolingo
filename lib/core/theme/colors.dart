import 'package:flutter/material.dart';

/// [Color Palette] Vibrant Candy Crush-style color scheme.
///
/// Provides a rich, energetic color palette inspired by Candy Crush aesthetics.
/// All colors are carefully selected for visual harmony and accessibility.
///
/// Purpose: Centralize color definitions for consistent theming
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors (Vibrant Blues/Purples)
  /// [Color] Primary brand color - electric blue
  ///
  /// Rationale: Energetic, modern, associated with learning and technology
  /// Usage: Main buttons, headers, key UI elements
  static const Color primary = Color(0xFF3B82F6); // Electric Blue

  /// [Color] Primary dark variation for emphasis
  static const Color primaryDark = Color(0xFF2563EB);

  /// [Color] Primary light variation for backgrounds
  static const Color primaryLight = Color(0xFF93C5FD);

  // Secondary Colors (Vibrant Greens)
  /// [Color] Secondary color - success green
  ///
  /// Rationale: Indicates correct answers, positive feedback, progress
  /// Usage: Correct answer indicators, achievement badges, success messages
  static const Color secondary = Color(0xFF10B981); // Success Green

  /// [Color] Secondary dark variation
  static const Color secondaryDark = Color(0xFF059669);

  /// [Color] Secondary light variation
  static const Color secondaryLight = Color(0xFF6EE7B7);

  // Accent Colors (Vibrant Purples/Pinks)
  /// [Color] Accent color - vibrant purple
  ///
  /// Rationale: Draws attention to special features, gamification elements
  /// Usage: Streak indicators, special achievements, premium features
  static const Color accent = Color(0xFF8B5CF6); // Vibrant Purple

  /// [Color] Accent pink for variety
  ///
  /// Rationale: Adds visual diversity and excitement
  /// Usage: Confetti particles, celebration effects
  static const Color accentPink = Color(0xFFEC4899);

  /// [Color] Accent orange for energy
  ///
  /// Rationale: High-energy color for urgent actions or rewards
  /// Usage: Flame streak icons, bonus point indicators
  static const Color accentOrange = Color(0xFFF59E0B);

  // Error and Warning Colors
  /// [Color] Error color - warm red
  ///
  /// Rationale: Indicates incorrect answers without being harsh
  /// Usage: Wrong answer indicators, error messages
  static const Color error = Color(0xFFEF4444);

  /// [Color] Warning color - amber
  ///
  /// Rationale: Alerts user to non-critical issues
  /// Usage: Notification badges, attention-needed indicators
  static const Color warning = Color(0xFFFBBF24);

  // Neutral Colors
  /// [Color] Background color - off-white
  ///
  /// Rationale: Softer than pure white, reduces eye strain
  /// Usage: Main app background, card backgrounds
  static const Color background = Color(0xFFF9FAFB);

  /// [Color] Surface color - pure white
  ///
  /// Rationale: Clean, provides elevation contrast
  /// Usage: Cards, dialogs, elevated surfaces
  static const Color surface = Color(0xFFFFFFFF);

  /// [Color] Dark background for dark mode
  static const Color backgroundDark = Color(0xFF1F2937);

  /// [Color] Dark surface for dark mode
  static const Color surfaceDark = Color(0xFF374151);

  // Text Colors
  /// [Color] Primary text color - dark gray
  ///
  /// Rationale: High contrast with background, readable
  /// Usage: Body text, headings, labels
  static const Color textPrimary = Color(0xFF111827);

  /// [Color] Secondary text color - medium gray
  ///
  /// Rationale: Less emphasis than primary, still readable
  /// Usage: Subtitles, descriptions, secondary information
  static const Color textSecondary = Color(0xFF6B7280);

  /// [Color] Disabled text color - light gray
  ///
  /// Rationale: Clearly indicates non-interactive elements
  /// Usage: Disabled buttons, inactive UI elements
  static const Color textDisabled = Color(0xFF9CA3AF);

  /// [Color] Text color on dark backgrounds
  static const Color textOnDark = Color(0xFFF9FAFB);

  // Gradient Colors (for Candy Crush-style effects)
  /// [List<Color>] Primary gradient - blue to purple
  ///
  /// Rationale: Creates depth and visual interest
  /// Usage: Buttons, headers, special UI elements
  static const List<Color> gradientPrimary = [
    Color(0xFF3B82F6), // Electric Blue
    Color(0xFF8B5CF6), // Vibrant Purple
  ];

  /// [List<Color>] Success gradient - green to cyan
  ///
  /// Rationale: Reinforces positive feedback
  /// Usage: Correct answer animations, achievement unlocks
  static const List<Color> gradientSuccess = [
    Color(0xFF10B981), // Success Green
    Color(0xFF06B6D4), // Cyan
  ];

  /// [List<Color>] Celebration gradient - pink to orange
  ///
  /// Rationale: Maximum visual excitement for celebrations
  /// Usage: Confetti, fireworks, lesson completion
  static const List<Color> gradientCelebration = [
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Orange
  ];

  /// [List<Color>] Streak gradient - orange to red
  ///
  /// Rationale: "Fire" theme for streaks
  /// Usage: Streak indicators, flame icons
  static const List<Color> gradientStreak = [
    Color(0xFFF59E0B), // Orange
    Color(0xFFEF4444), // Red
  ];

  // Special Effect Colors
  /// [Color] Star color - golden yellow
  ///
  /// Rationale: Universal symbol for achievement and excellence
  /// Usage: Star ratings, achievement icons
  static const Color star = Color(0xFFFBBF24);

  /// [Color] Points color - golden
  ///
  /// Rationale: Makes points feel valuable and rewarding
  /// Usage: Point counters, point animations
  static const Color points = Color(0xFFF59E0B);

  /// [Color] Shadow color for elevation
  ///
  /// Rationale: Subtle depth without being too dark
  /// Usage: Card shadows, button elevations
  static const Color shadow = Color(0x1A000000); // 10% black

  /// [Color] Overlay color for modals
  ///
  /// Rationale: Dims background without completely hiding it
  /// Usage: Dialog backgrounds, modal overlays
  static const Color overlay = Color(0x80000000); // 50% black
}
