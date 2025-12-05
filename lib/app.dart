import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/app_theme.dart';
import 'package:speckkit_duolingo/core/utils/constants.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/pages/main_menu_page.dart';

/// [StatelessWidget] Root widget of the application.
///
/// Configures the MaterialApp with:
/// - App name and theme
/// - Initial route and routing
/// - Debug banner configuration
///
/// Purpose: Provide app-wide configuration and navigation structure
///
/// Note: Routes will be added as features are implemented in subsequent phases
class DuolingoApp extends StatelessWidget {
  /// Creates the root app widget.
  const DuolingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // TODO: Add user preference for theme mode

      // Routing
      // TODO: Add routes as features are implemented
      // Example:
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const MainMenuPage(),
      //   '/lesson-map': (context) => const LessonMapPage(),
      //   '/lesson': (context) => const LessonPage(),
      //   '/settings': (context) => const SettingsPage(),
      // },

      // Main menu as home screen
      home: const MainMenuPage(),
    );
  }
}
