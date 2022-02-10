part of 'home_cubit.dart';
abstract class HomeCubitState {}

class HomeCubitInitialState extends HomeCubitState {
  @override
  String toString() => 'Home Cubit Initial State';
}

class HomeCubitLoadingState extends HomeCubitState {

  @override
  String toString() => 'Home Cubit Loading State';
}

class HomeCubitLoadedState extends HomeCubitState {

  /// Initializes
  HomeCubitLoadedState({
    this.activeSymbols,
    ActiveSymbol? selectedSymbol,
  }) : _selectedSymbol = selectedSymbol ?? activeSymbols?.first;

  /// List of symbols
  final List<ActiveSymbol>? activeSymbols;

  final ActiveSymbol? _selectedSymbol;

  /// Selected symbol
  ActiveSymbol? get selectedSymbol => _selectedSymbol;

  @override
  String toString() => 'Home Cubit Loaded State';
}

/// ActiveSymbolsError
class ActiveSymbolsError extends HomeCubitState {
  /// Initializes
  ActiveSymbolsError(this.message);

  /// Error message
  final String? message;

  @override
  String toString() => 'ActiveSymbolsError';
}


