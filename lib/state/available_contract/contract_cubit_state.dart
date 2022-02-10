
part of 'contract_cubit.dart';

abstract class ContractCubitState {}

class ContractCubitInitialState extends ContractCubitState {
  @override
  String toString() => 'Home Cubit Initial State';
}

class ContractCubitLoadingState extends ContractCubitState {

  @override
  String toString() => 'Home Cubit Loading State';
}

/// ActiveSymbolsError
class ContractError extends ContractCubitState {
  /// Initializes
  ContractError(this.message);

  /// Error message
  final String? message;

  @override
  String toString() => 'ActiveSymbolsError';
}

class AvailableContractsLoaded extends ContractCubitState {
  ///Initializes
  AvailableContractsLoaded({
    this.contracts,
    AvailableContractModel? selectedContract,
  }) : _selectedContract =
      selectedContract ?? contracts?.availableContracts?.first;

  /// Contracts
  final ContractsForSymbol? contracts;

  final AvailableContractModel? _selectedContract;

  /// Selected Contract
  AvailableContractModel? get selectedContract => _selectedContract;

  @override
  String toString() =>
      'AvailableContractsLoaded ${contracts!.availableContracts!.length} contracts';
}