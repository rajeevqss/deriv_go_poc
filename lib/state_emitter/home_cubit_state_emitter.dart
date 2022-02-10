import 'package:deriv_go_app/event_listener/home_cubit_event_listener.dart';
import 'package:deriv_go_app/state/home/home_cubit.dart';
import 'package:flutter_deriv_bloc_manager/base_state_emitter.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/base_bloc_manager.dart';

class HomeCubitStateEmitter
    extends BaseStateEmitter<HomeCubitEventListener, HomeCubit> {
  /// Initializes account settings state emitter.
  HomeCubitStateEmitter(BaseBlocManager blocManager) : super(blocManager);

  @override
  void handleStates({
    required HomeCubitEventListener eventListener,
    required Object state,
  }) {

  }
}