import 'package:bloc/bloc.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/exceptions/active_symbols_exception.dart';
import 'package:flutter_deriv_api/basic_api/generated/active_symbols_send.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  HomeCubit() : super(HomeCubitInitialState());

  Future<void> getActiveSymbol() async {
    try {
      emit(HomeCubitLoadingState());
      final List<ActiveSymbol> symbols = await _fetchActiveSymbols();
      emit(HomeCubitLoadedState(activeSymbols: symbols));
    } on ActiveSymbolsException catch (error) {
      emit(ActiveSymbolsError(error.message));
    }
  }


  Future<List<ActiveSymbol>> _fetchActiveSymbols() async =>
      ActiveSymbol.fetchActiveSymbols(const ActiveSymbolsRequest(
        activeSymbols: 'brief',
        productType: 'basic',
      ));
}
