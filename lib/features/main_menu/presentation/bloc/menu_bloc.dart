import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/bloc/menu_event.dart';
import 'package:speckkit_duolingo/features/main_menu/presentation/bloc/menu_state.dart';

/// [BLoC] Manages main menu state and navigation logic.
///
/// Handles user interactions in the main menu:
/// - Menu initialization
/// - Navigation to lessons, settings, about
/// - UI state transitions
///
/// Purpose: Coordinate main menu UI state and navigation events
///
/// Constitutional Requirement: Principle II - BLoC state management
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  /// Creates a MenuBloc with initial state.
  MenuBloc() : super(const MenuInitial()) {
    on<MenuStarted>(_onMenuStarted);

    // Use restartable transformer for navigation events
    // This cancels any in-progress navigation when a new one is triggered
    // Prevents rapid-fire button clicks from stacking navigation events
    on<NavigateToLessons>(_onNavigateToLessons, transformer: restartable());
    on<NavigateToSettings>(_onNavigateToSettings, transformer: restartable());
    on<NavigateToAbout>(_onNavigateToAbout, transformer: restartable());

    AppLogger.debug('MenuBloc', 'constructor',
        () => 'MenuBloc initialized with restartable navigation transformers');
  }

  /// [Event Handler] Handles menu initialization when screen loads.
  ///
  /// Transitions from MenuInitial to MenuLoaded state.
  /// This prepares the UI for user interaction.
  ///
  /// Parameters:
  /// - event: The MenuStarted event
  /// - emit: Function to emit new states
  Future<void> _onMenuStarted(
    MenuStarted event,
    Emitter<MenuState> emit,
  ) async {
    AppLogger.info('MenuBloc', '_onMenuStarted',
        () => 'Main menu started - initializing UI');

    // Emit loaded state to display menu
    emit(const MenuLoaded());

    AppLogger.debug('MenuBloc', '_onMenuStarted',
        () => 'Menu loaded and ready for interaction');
  }

  /// [Event Handler] Handles navigation to lessons/learning section.
  ///
  /// Emits MenuNavigating state with '/lessons' route.
  /// UI layer listens to this state and performs navigation.
  ///
  /// Parameters:
  /// - event: The NavigateToLessons event
  /// - emit: Function to emit new states
  Future<void> _onNavigateToLessons(
    NavigateToLessons event,
    Emitter<MenuState> emit,
  ) async {
    AppLogger.info('MenuBloc', '_onNavigateToLessons',
        () => 'User tapped "Start Learning" - navigating to lessons');

    // Emit navigating state with lessons route
    emit(const MenuNavigating(route: '/lessons'));

    AppLogger.debug(
        'MenuBloc', '_onNavigateToLessons', () => 'Navigation state emitted');
  }

  /// [Event Handler] Handles navigation to settings page.
  ///
  /// Emits MenuNavigating state with '/settings' route.
  /// UI layer listens to this state and performs navigation.
  ///
  /// Parameters:
  /// - event: The NavigateToSettings event
  /// - emit: Function to emit new states
  Future<void> _onNavigateToSettings(
    NavigateToSettings event,
    Emitter<MenuState> emit,
  ) async {
    AppLogger.info('MenuBloc', '_onNavigateToSettings',
        () => 'User tapped "Settings" - navigating to settings');

    // Emit navigating state with settings route
    emit(const MenuNavigating(route: '/settings'));

    AppLogger.debug(
        'MenuBloc', '_onNavigateToSettings', () => 'Navigation state emitted');
  }

  /// [Event Handler] Handles showing the about dialog.
  ///
  /// Emits MenuNavigating state with 'about' identifier.
  /// UI layer listens to this state and shows dialog instead of navigating.
  ///
  /// Parameters:
  /// - event: The NavigateToAbout event
  /// - emit: Function to emit new states
  Future<void> _onNavigateToAbout(
    NavigateToAbout event,
    Emitter<MenuState> emit,
  ) async {
    AppLogger.info('MenuBloc', '_onNavigateToAbout',
        () => 'User tapped "About" - showing about dialog');

    // Emit navigating state with about identifier (triggers dialog, not route)
    emit(const MenuNavigating(route: 'about'));

    AppLogger.debug(
        'MenuBloc', '_onNavigateToAbout', () => 'About dialog state emitted');
  }

  @override
  Future<void> close() {
    AppLogger.debug('MenuBloc', 'close', () => 'MenuBloc closing');
    return super.close();
  }
}
