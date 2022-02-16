import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:deriv_go_app/state/home/home_cubit.dart';
import 'package:flutter_deriv_api/api/api_initializer.dart';
import 'home_active_symbol_cubit_data.dart';



class MockActiveSymbolCubit extends MockCubit<HomeCubitState>
    implements HomeCubit {}


class FakeActiveSymbolState extends Fake implements HomeCubitState {}


void main() {
  setUpAll(() {
    registerFallbackValue(FakeActiveSymbolState());
   // registerFallbackValue(FakeSyncTimeState());
   // BlocManager.instance.register<SyncTimeCubit>(MockSyncTimeCubit());
    APIInitializer().initialize(isMock: true);
  });

  group('active symbols test =>', () {
    test('should fetch active symbols.', () async {
      final MockActiveSymbolCubit activeSymbolCubit = MockActiveSymbolCubit();

      whenListen(
        activeSymbolCubit,
        Stream<HomeCubitState>.fromIterable(
          <HomeCubitState>[
            HomeCubitInitialState(),
            HomeCubitLoadingState(),
            HomeCubitLoadedState(
              activeSymbols: activeSymbols,
              //assets: assets,
            ),
          ],
        ),

      );

      await expectLater(
        activeSymbolCubit.stream,
        emitsInOrder(
          <dynamic>[
            isA<HomeCubitInitialState>(),
            isA<HomeCubitLoadingState>(),
            isA<HomeCubitLoadedState>(),
          ],
        ),
      );

      expect(activeSymbolCubit.state, isA<HomeCubitLoadedState>());

      final HomeCubitLoadedState currentState =
      activeSymbolCubit.state as HomeCubitLoadedState;

      expect(currentState.activeSymbols, isNotNull);
      expect(currentState.activeSymbols, isA<List<ActiveSymbol>>());

      // expect(currentState.assets, isNotNull);
      // expect(currentState.assets, isA<List<Asset>>());
    });

    final Exception exception = Exception('Active Symbol Cubit Exception.');

    blocTest<HomeCubit, HomeCubitState>(
      'captures exceptions.',
      build: () => HomeCubit(),
      act: (HomeCubit cubit) => cubit.addError(exception),
      errors: () => <Matcher>[equals(exception)],
    );
  });
}
