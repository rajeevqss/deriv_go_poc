import 'package:bloc_test/bloc_test.dart';
import 'package:deriv_go_app/state/available_contract/contract_cubit.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_deriv_api/api/contract/contracts_for/contracts_for_symbol.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:deriv_go_app/state/home/home_cubit.dart';
import 'package:flutter_deriv_api/api/api_initializer.dart';

import '../home/home_active_symbol_cubit_data.dart';




class MockContractCubit extends MockCubit<ContractCubitState>
    implements ContractCubit {}


class FakeContractState extends Fake implements ContractCubitState {}


void main() {
  setUpAll(() {
    registerFallbackValue(FakeContractState());
    // registerFallbackValue(FakeSyncTimeState());
    // BlocManager.instance.register<SyncTimeCubit>(MockSyncTimeCubit());
    APIInitializer().initialize(isMock: true);
  });

  group('Contract test =>', () {
    test('should fetch Contract.', () async {
      final MockContractCubit contractCubit = MockContractCubit();

      whenListen(
        contractCubit,
        Stream<ContractCubitState>.fromIterable(
          <ContractCubitState>[
            ContractCubitInitialState(),
            ContractCubitLoadingState(),
            AvailableContractsLoaded(contracts: ContractsForSymbol(availableContracts: contractsForSymbol),
              //assets: assets,
            ),
          ],
        ),

      );

      await expectLater(
        contractCubit.stream,
        emitsInOrder(
          <dynamic>[
            isA<ContractCubitInitialState>(),
            isA<ContractCubitLoadingState>(),
            isA<AvailableContractsLoaded>(),
          ],
        ),
      );

      expect(contractCubit.state, isA<AvailableContractsLoaded>());

      final AvailableContractsLoaded currentState =
      contractCubit.state as AvailableContractsLoaded;

      expect(currentState.contracts, isNotNull);
      expect(currentState.contracts, isA<ContractsForSymbol>());

    });

    final Exception exception = Exception('Contract Cubit Exception.');

    blocTest<ContractCubit, ContractCubitState>(
      'captures exceptions.',
      build: () => ContractCubit(),
      act: (ContractCubit cubit) => cubit.addError(exception),
      errors: () => <Matcher>[equals(exception)],
    );
  });
}
