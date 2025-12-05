import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/bloc/menu_bloc.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/bloc/menu_event.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/bloc/menu_state.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/widgets/about_dialog.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/widgets/animated_background.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/widgets/menu_button.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/widgets/points_display.dart';

/// [StatelessWidget] Main menu screen with Candy Crush aesthetics.
///
/// Features:
/// - Vibrant animated background
/// - Points display with animated counter
/// - Interactive menu buttons with animations
/// - Navigation to lessons, settings, and about
///
/// Purpose: Serve as the app's main entry point and navigation hub
///
/// Navigation: Initial route after app launch
class MainMenuPage extends StatelessWidget {
  /// Creates a MainMenuPage.
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(const MenuStarted()),
      child: const _MainMenuView(),
    );
  }
}

/// [StatelessWidget] Main menu view with BLoC integration.
///
/// Separated from MainMenuPage to avoid recreating BLoC on rebuilds.
class _MainMenuView extends StatelessWidget {
  const _MainMenuView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove default app bar for full-screen immersive experience
      body: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          // Handle navigation based on state changes
          if (state is MenuNavigating) {
            _handleNavigation(context, state.route);
          }
        },
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Animated gradient background
                const AnimatedBackground(),

                // Main content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        // Header with points display
                        _buildHeader(),

                        const Spacer(),

                        // App title
                        _buildTitle(),

                        const SizedBox(height: 48),

                        // Menu buttons
                        if (state is MenuLoaded || state is MenuNavigating)
                          _buildMenuButtons(context),

                        const Spacer(),

                        // Footer
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// [Method] Builds the header section with points display.
  ///
  /// Shows user's current points balance.
  Widget _buildHeader() {
    // TODO: Get actual points from ProgressBloc when implemented
    const currentPoints = 0; // Placeholder until progress tracking is added

    return const Align(
      alignment: Alignment.centerRight,
      child: PointsDisplay(points: currentPoints),
    );
  }

  /// [Method] Builds the app title with animated text.
  ///
  /// Displays prominent app branding.
  Widget _buildTitle() {
    return Column(
      children: [
        // App icon/logo
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.school,
            size: 70,
            color: Colors.purple.shade400,
          ),
        ),

        const SizedBox(height: 24),

        // App name
        const Text(
          'SpeckKit Duolingo',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Tagline
        const Text(
          'Learn languages with fun!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// [Method] Builds the menu buttons section.
  ///
  /// Creates interactive buttons for navigation to different sections.
  Widget _buildMenuButtons(BuildContext context) {
    return Column(
      children: [
        // Start Learning button
        MenuButton(
          label: 'Start Learning',
          icon: Icons.play_arrow,
          onTap: () {
            context.read<MenuBloc>().add(const NavigateToLessons());
          },
        ),

        const SizedBox(height: 16),

        // Settings button
        MenuButton(
          label: 'Settings',
          icon: Icons.settings,
          gradientColors: const [
            Color(0xFF6366F1), // Indigo
            Color(0xFF8B5CF6), // Purple
          ],
          onTap: () {
            context.read<MenuBloc>().add(const NavigateToSettings());
          },
        ),

        const SizedBox(height: 16),

        // About button
        MenuButton(
          label: 'About',
          icon: Icons.info,
          gradientColors: const [
            Color(0xFF10B981), // Green
            Color(0xFF06B6D4), // Cyan
          ],
          onTap: () {
            context.read<MenuBloc>().add(const NavigateToAbout());
          },
        ),
      ],
    );
  }

  /// [Method] Builds the footer section.
  ///
  /// Displays app version or other footer information.
  Widget _buildFooter() {
    return const Text(
      'Version 1.0.0',
      style: TextStyle(
        color: Colors.white70,
        fontSize: 12,
      ),
    );
  }

  /// [Method] Handles navigation based on MenuNavigating state.
  ///
  /// Routes to different screens or shows dialogs based on the route.
  ///
  /// Parameters:
  /// - context: Build context for navigation
  /// - route: Route identifier or dialog name
  void _handleNavigation(BuildContext context, String route) {
    AppLogger.debug('MainMenuPage', '_handleNavigation',
        () => 'Handling navigation to: $route');

    switch (route) {
      case '/lessons':
        // TODO: Navigate to lesson map when implemented
        AppLogger.warning('MainMenuPage', '_handleNavigation',
            () => 'Lesson map not yet implemented (Phase 5)');
        _showComingSoonDialog(context, 'Lessons');

        // Reset state to allow subsequent clicks
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            context.read<MenuBloc>().add(const MenuStarted());
          }
        });
        break;

      case '/settings':
        // TODO: Navigate to settings when implemented
        AppLogger.warning('MainMenuPage', '_handleNavigation',
            () => 'Settings not yet implemented (Phase 8)');
        _showComingSoonDialog(context, 'Settings');

        // Reset state to allow subsequent clicks
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            context.read<MenuBloc>().add(const MenuStarted());
          }
        });
        break;

      case 'about':
        // Show about dialog
        AppLogger.debug(
            'MainMenuPage', '_handleNavigation', () => 'Showing about dialog');

        showDialog<void>(
          context: context,
          barrierDismissible: true, // Allow dismissing by tapping outside
          builder: (context) => const AboutDialogWidget(),
        ).then((_) {
          // Log when dialog is dismissed
          AppLogger.debug('MainMenuPage', '_handleNavigation',
              () => 'About dialog dismissed');
        });

        // CRITICAL: Reset state back to MenuLoaded after showing dialog
        // This prevents the state from staying at MenuNavigating('about')
        // which would block future dialog triggers due to Equatable equality
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            context.read<MenuBloc>().add(const MenuStarted());
            AppLogger.debug('MainMenuPage', '_handleNavigation',
                () => 'State reset to MenuLoaded to allow future dialogs');
          }
        });
        break;

      default:
        AppLogger.warning(
            'MainMenuPage', '_handleNavigation', () => 'Unknown route: $route');
    }
  }

  /// [Method] Shows a "Coming Soon" dialog for unimplemented features.
  ///
  /// Parameters:
  /// - context: Build context for dialog
  /// - featureName: Name of the feature coming soon
  void _showComingSoonDialog(BuildContext context, String featureName) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName Coming Soon'),
        content: Text(
          '$featureName will be available in the next phase of development!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
