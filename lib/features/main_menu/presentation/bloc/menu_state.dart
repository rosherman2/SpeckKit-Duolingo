import 'package:equatable/equatable.dart';

/// [State Base Class] Base class for all menu-related states.
///
/// All menu states extend Equatable for value equality comparisons.
/// States represent different conditions of the main menu UI.
///
/// Purpose: Define all possible states of the main menu
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

/// [State] Initial state before menu initialization.
///
/// This is the default state when MenuBloc is first created.
/// Transitions to MenuLoaded after MenuStarted event.
///
/// UI Impact: Can show loading indicator or splash screen
class MenuInitial extends MenuState {
  const MenuInitial();
}

/// [State] Menu is loaded and ready for user interaction.
///
/// All menu elements are displayed and functional.
/// User can tap buttons to navigate to different sections.
///
/// UI Impact: Display full menu with all buttons enabled
class MenuLoaded extends MenuState {
  const MenuLoaded();
}

/// [State] User is navigating to a different screen.
///
/// Indicates a navigation action is in progress.
/// The route parameter specifies the destination.
///
/// UI Impact: May show transition animation before navigation
class MenuNavigating extends MenuState {
  /// [String] The route path to navigate to
  ///
  /// Examples:
  /// - '/lessons' for lesson map
  /// - '/settings' for settings page
  /// - 'about' for about dialog (not a route, triggers dialog)
  final String route;

  /// Creates a MenuNavigating state for the given route.
  ///
  /// Parameters:
  /// - route: Destination route path or dialog identifier
  const MenuNavigating({required this.route});

  @override
  List<Object?> get props => [route];
}
