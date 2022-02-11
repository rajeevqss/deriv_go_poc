part of 'tick_cubit.dart';


/// TicksState
abstract class TicksCubitState {
  /// Initializes
  TicksCubitState();
}

/// TicksLoading
class TicksLoading extends TicksCubitState {
  @override
  String toString() => 'TicksLoading...';
}

/// TicksError
class TicksError extends TicksCubitState {
  /// Initializes
  TicksError(this.message);

  /// Error message
  final String message;

  @override
  String toString() => 'TicksError';
}

/// TicksLoaded
class TicksLoaded extends TicksCubitState {
  /// Initializes
  TicksLoaded(this.tick);

  /// Loaded tick
  final Tick tick;

  @override
  String toString() => 'Tick $tick loaded';
}
