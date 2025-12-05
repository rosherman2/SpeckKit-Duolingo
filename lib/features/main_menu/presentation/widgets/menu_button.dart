import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/animations.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';

/// [StatefulWidget] Interactive menu button with tap animation and sound effect.
///
/// Provides tactile feedback through:
/// - Scale-down animation on press
/// - Bounce-back animation on release
/// - Sound effect playback (when audio system is integrated)
/// - Vibrant gradient styling
///
/// Purpose: Consistent, themeed button for main menu actions
///
/// Navigation: Used in MainMenuPage for all menu options
class MenuButton extends StatefulWidget {
  /// [String] Text label displayed on the button
  final String label;

  /// [VoidCallback] Function called when button is tapped
  final VoidCallback onTap;

  /// [IconData] Optional icon displayed before the label
  final IconData? icon;

  /// [List<Color>] Optional custom gradient colors
  ///
  /// If null, uses AppTheme's primary gradient from theme
  final List<Color>? gradientColors;

  /// Creates a MenuButton with the given label and tap handler.
  ///
  /// Parameters:
  /// - label: Button text
  /// - onTap: Callback when button is tapped
  /// - icon: Optional leading icon
  /// - gradientColors: Optional custom gradient (uses theme default if null)
  const MenuButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.gradientColors,
    super.key,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

/// [State] Manages MenuButton's animation state.
///
/// Handles the scale animation for press/release feedback.
class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  /// [AnimationController] Controls the scale animation timing
  late AnimationController _controller;

  /// [Animation<double>] Animates the button scale from 1.0 to buttonPressScale
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with bounce curve
    _controller = AnimationController(
      duration: AppAnimations.veryQuick,
      vsync: this,
    );

    // Create scale animation from 1.0 (normal) to buttonPressScale (pressed)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.buttonPressScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.bounceOut,
      ),
    );

    AppLogger.debug('MenuButton', 'initState',
        () => 'MenuButton initialized: ${widget.label}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// [Method] Handles button press start.
  ///
  /// Triggers scale-down animation and logs the interaction.
  void _onTapDown(TapDownDetails details) {
    _controller.forward();

    AppLogger.debug(
        'MenuButton', '_onTapDown', () => 'Button pressed: ${widget.label}');
  }

  /// [Method] Handles button press end.
  ///
  /// Triggers scale-up animation, plays sound effect, and executes callback.
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();

    // TODO: Play button tap sound effect when AudioManager is integrated
    // AudioManager.playSound('button_tap');

    AppLogger.info(
        'MenuButton', '_onTapUp', () => 'Button tapped: ${widget.label}');

    // Execute the tap callback
    widget.onTap();
  }

  /// [Method] Handles button press cancel (e.g., swipe away).
  ///
  /// Reverses the scale animation without executing the callback.
  void _onTapCancel() {
    _controller.reverse();

    AppLogger.debug('MenuButton', '_onTapCancel',
        () => 'Button press cancelled: ${widget.label}');
  }

  @override
  Widget build(BuildContext context) {
    // Get gradient colors from widget or use theme default
    final colors = widget.gradientColors ?? AppColors.gradientPrimary;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
