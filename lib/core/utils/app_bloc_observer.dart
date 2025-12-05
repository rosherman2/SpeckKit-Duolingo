import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';

/// [BlocObserver] Global observer for all BLoC events and state changes.
///
/// Provides centralized monitoring of:
/// - BLoC creation and disposal
/// - Event processing
/// - State transitions
/// - Errors and exceptions
///
/// Purpose: Enhanced debugging and error tracking across all BLoCs
///
/// Constitutional Requirement: Principle III - Observability & Debugging
class AppBlocObserver extends BlocObserver {
  /// Creates an AppBlocObserver instance.
  const AppBlocObserver();

  /// Called when a BLoC is created.
  ///
  /// Parameters:
  /// - bloc: The BLoC instance being created
  ///
  /// Logs: BLoC type and creation timestamp
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.debug(
        'BlocObserver', 'onCreate', () => '${bloc.runtimeType} created');
  }

  /// Called when an event is added to a BLoC.
  ///
  /// Parameters:
  /// - bloc: The BLoC receiving the event
  /// - event: The event being processed
  ///
  /// Logs: Event type and target BLoC
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug('BlocObserver', 'onEvent',
        () => '${bloc.runtimeType} received ${event.runtimeType}');
  }

  /// Called when a BLoC's state changes.
  ///
  /// Parameters:
  /// - bloc: The BLoC whose state changed
  /// - change: Object containing current and next states
  ///
  /// Logs: State transition with timestamps
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.debug(
        'BlocObserver',
        'onChange',
        () =>
            '${bloc.runtimeType}: ${change.currentState.runtimeType} → ${change.nextState.runtimeType}');
  }

  /// Called when a state transition is complete.
  ///
  /// Parameters:
  /// - bloc: The BLoC that transitioned
  /// - transition: Object with event, current state, and next state
  ///
  /// Logs: Complete transition flow
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    AppLogger.info(
        'BlocObserver',
        'onTransition',
        () => '${bloc.runtimeType} transition: '
            '${transition.currentState.runtimeType} → '
            '${transition.nextState.runtimeType} '
            'via ${transition.event.runtimeType}');
  }

  /// Called when an error occurs in a BLoC.
  ///
  /// Parameters:
  /// - bloc: The BLoC where error occurred
  /// - error: The error object
  /// - stackTrace: Stack trace for debugging
  ///
  /// Logs: Error details with full stack trace
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error('BlocObserver', 'onError',
        () => '${bloc.runtimeType} error: $error\nStack: $stackTrace');
  }

  /// Called when a BLoC is closed/disposed.
  ///
  /// Parameters:
  /// - bloc: The BLoC being disposed
  ///
  /// Logs: BLoC disposal for lifecycle tracking
  @override
  void onClose(BlocBase<dynamic> bloc) {
    AppLogger.debug(
        'BlocObserver', 'onClose', () => '${bloc.runtimeType} closed');
    super.onClose(bloc);
  }
}
