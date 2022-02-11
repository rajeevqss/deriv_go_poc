import 'package:bloc/bloc.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_deriv_api/api/contract/contracts_for/contracts_for_symbol.dart';
import 'package:flutter_deriv_api/api/contract/contracts_for/exceptions/contract_for_symbol_exception.dart';
import 'package:flutter_deriv_api/api/contract/models/available_contract_model.dart';
import 'package:flutter_deriv_api/basic_api/generated/active_symbols_send.dart';
import 'package:flutter_deriv_api/basic_api/generated/contracts_for_send.dart';

part 'contract_cubit_state.dart';

class ContractCubit extends Cubit<ContractCubitState> {
  ContractCubit() : super(ContractCubitInitialState());


  Future<void> getAvailableContracts( ActiveSymbol selectedSymbol) async {
    try {
      emit(ContractCubitLoadingState());
      final ContractsForSymbol contracts = await _fetchAvailableContracts(selectedSymbol);
      emit(AvailableContractsLoaded(contracts: contracts));
    } on ContractsForSymbolException catch (error) {
      emit(ContractError(error.message));
    }
  }

  Future<ContractsForSymbol> _fetchAvailableContracts(
      ActiveSymbol selectedSymbol,
      ) async =>
      ContractsForSymbol.fetchContractsForSymbol(
        ContractsForRequest(contractsFor: selectedSymbol.symbol),
      );


}
