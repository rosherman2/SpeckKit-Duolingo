import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speckkit_duolingo/app.dart';
import 'package:speckkit_duolingo/core/di/injection.dart';
import 'package:speckkit_duolingo/core/utils/app_bloc_observer.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';

/// [Main Entry Point] Application initialization and startup.
///
/// Initializes all required services before running the app:
/// 1. Hive database for local storage
/// 2. AppLogger for structured logging
/// 3. Dependency injection container
///
/// Then launches the Flutter app widget tree.
///
/// Purpose: Bootstrap the application with all necessary services
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  AppLogger.debug('Main', 'main',
      () => 'Hive initialized. Progress box will open on first use.');

  // Initialize AppLogger with console format
  await AppLogger.initialize(
    format: LogFormat.console,
    maxFileSize: 5 * 1024 * 1024, // 5MB per file
    maxFiles: 5, // Keep 5 most recent files
  );

  // Initialize BLoC observer for global monitoring
  Bloc.observer = const AppBlocObserver();
  AppLogger.info(
      'Main', 'main', () => 'BlocObserver initialized for global monitoring');

  AppLogger.info('Main', 'main', () => 'App starting...');

  // Initialize dependency injection (includes progress tracking)
  await initializeDependencies();

  AppLogger.info('Main', 'main', () => 'Dependencies initialized');

  // Run the app
  runApp(const DuolingoApp());

  AppLogger.info('Main', 'main', () => 'App launched successfully');
}
