import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';
import 'package:speckkit_duolingo/core/utils/constants.dart';

/// [StatelessWidget] Displays app information, version, and credits.
///
/// Shows:
/// - App name and version
/// - Brief description
/// - Credits for development
/// - Copyright information
///
/// Purpose: Provide app information to users
///
/// Navigation: Shown via showDialog() from MainMenuPage
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => const AboutDialogWidget(),
/// );
/// ```
class AboutDialogWidget extends StatelessWidget {
  /// Creates an AboutDialogWidget.
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App icon/logo placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientPrimary,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school,
                  size: 48,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              // App name
              Text(
                AppConstants.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Version
              Text(
                'Version ${AppConstants.appVersion}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Description
              const Text(
                'A modern Duolingo-style language learning game with Candy Crush aesthetics. '
                'Learn English and Hebrew through interactive lessons with gamification.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Divider
              Container(
                height: 1,
                color: AppColors.textDisabled,
              ),

              const SizedBox(height: 24),

              // Credits
              const Text(
                'Credits',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Developed with ❤️ using Flutter\n\n'
                'Built with:\n'
                '• flutter_bloc for state management\n'
                '• Hive for local storage\n'
                '• Lottie for animations\n'
                '• just_audio for sound effects',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Copyright
              Text(
                '© ${DateTime.now().year} ${AppConstants.appName}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textDisabled,
                ),
              ),

              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
