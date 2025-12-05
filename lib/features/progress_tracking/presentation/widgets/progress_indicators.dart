import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';

/// [Widget] Custom loading indicator for progress tracking feature.
///
/// Displays a circular progress indicator with app theming.
/// Can be used with BLoC loading states to show operation in progress.
///
/// Purpose: Consistent loading UI across progress tracking screens
///
/// Constitutional Requirement: Premium UX with smooth animations
class ProgressLoadingIndicator extends StatelessWidget {
  /// [double] Size of the circular progress indicator
  final double size;

  /// [String?] Optional message to display below the indicator
  final String? message;

  /// Creates a ProgressLoadingIndicator.
  ///
  /// Parameters:
  /// - size: Diameter of the circular indicator (default: 48)
  /// - message: Optional text to show below indicator
  const ProgressLoadingIndicator({
    super.key,
    this.size = 48.0,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// [Widget] Error display with retry button for progress tracking.
///
/// Shows error message and retry button when BLoC emits error state.
/// Integrates with retry events for automatic error recovery.
///
/// Purpose: Consistent error UI with retry capability
///
/// Constitutional Requirement: User-friendly error handling
class ProgressErrorIndicator extends StatelessWidget {
  /// [String] Error message to display
  final String message;

  /// [VoidCallback] Callback when retry button is tapped
  final VoidCallback onRetry;

  /// [bool] Whether retry is available for this error
  final bool canRetry;

  /// Creates a ProgressErrorIndicator.
  ///
  /// Parameters:
  /// - message: Error description for user
  /// - onRetry: Function to call on retry button tap
  /// - canRetry: Whether to show retry button (default: true)
  const ProgressErrorIndicator({
    super.key,
    required this.message,
    required this.onRetry,
    this.canRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),

            // Error message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry button (if retryable)
            if (canRetry) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// [Widget] Empty state indicator for progress tracking.
///
/// Shows when user has no progress data yet.
/// Encourages user to start first lesson.
///
/// Purpose: Friendly empty state with call-to-action
class ProgressEmptyIndicator extends StatelessWidget {
  /// [VoidCallback?] Optional callback when CTA button is tapped
  final VoidCallback? onStartLearning;

  /// Creates a ProgressEmptyIndicator.
  ///
  /// Parameters:
  /// - onStartLearning: Optional callback for start button
  const ProgressEmptyIndicator({
    super.key,
    this.onStartLearning,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Empty state icon
            Icon(
              Icons.school_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Start Your Journey!',
              style: TextStyle(
                fontSize: 24,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Complete lessons to earn points,\nbuild streaks, and unlock achievements!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // CTA button (if callback provided)
            if (onStartLearning != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onStartLearning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Start Learning',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
