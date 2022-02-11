import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_deriv_api/api/common/forget/forget_all.dart';
import 'package:flutter_deriv_api/api/common/tick/exceptions/tick_exception.dart';
import 'package:flutter_deriv_api/api/common/tick/tick.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_deriv_api/basic_api/generated/ticks_send.dart';

part 'tick_cubit_state.dart';

class TickCubit extends Cubit<TicksCubitState> {
  TickCubit() : super(TicksLoading());

 Future<void> getLivePrice(ActiveSymbol selectedSymbol) async{
  await _unsubscribeTick();

  _subscribeTick(selectedSymbol)
      .handleError((dynamic error) => error is TickException
      ? emit(TicksError(error.message!))
      : emit(TicksError(error.toString())))
      .listen((Tick? tick) => emit(TicksLoaded(tick!)));

}


  Stream<Tick?> _subscribeTick(ActiveSymbol selectedSymbol) =>
      Tick.subscribeTick(
        TicksRequest(ticks: selectedSymbol.symbol),
      );

  Future<ForgetAll> _unsubscribeTick() => Tick.unsubscribeAllTicks();

  @override
  Future<void> close() async {
    await _unsubscribeTick();

    await super.close();
  }
}