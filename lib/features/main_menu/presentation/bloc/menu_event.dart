import 'package:equatable/equatable.dart';

/// [Event Base Class] Base class for all menu-related events.
///
/// All menu events extend Equatable for value equality comparisons.
/// Events represent user actions in the main menu.
///
/// Purpose: Define all possible user interactions in the main menu
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

/// [Event] Triggered when the main menu screen is first displayed.
///
/// Initializes the menu state and prepares UI elements.
///
/// Usage: Dispatched automatically when MainMenuPage is mounted
class MenuStarted extends MenuEvent {
  const MenuStarted();
}

/// [Event] User navigated to the lessons/learning section.
///
/// Triggers navigation to the lesson map page where users select lessons.
///
/// Usage:
/// ```dart
/// context.read<MenuBloc>().add(const NavigateToLessons());
/// ```
class NavigateToLessons extends MenuEvent {
  const NavigateToLessons();
}

/// [Event] User navigated to the settings page.
///
/// Opens the app settings where users can adjust preferences.
///
/// Usage:
/// ```dart
/// context.read<MenuBloc>().add(const NavigateToSettings());
/// ```
class NavigateToSettings extends MenuEvent {
  const NavigateToSettings();
}

/// [Event] User requested to view the about dialog.
///
/// Shows app information, version, and credits.
///
/// Usage:
/// ```dart
/// context.read<MenuBloc>().add(const NavigateToAbout());
/// ```
class NavigateToAbout extends MenuEvent {
  const NavigateToAbout();
}
