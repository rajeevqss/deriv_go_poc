import 'package:deriv_go_app/state/available_contract/contract_cubit.dart';
import 'package:deriv_go_app/state/home/home_cubit.dart';
import 'package:deriv_go_app/state/tick/tick_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ActiveSymbol? _selectedLocation;
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    BlocManager.instance
        .fetch<TickCubit>().close();
  }
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
                width: double.infinity,
                child: Text(
                  'Active Symbol',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            BlocBuilder<HomeCubit, HomeCubitState>(
                bloc: BlocManager.instance.fetch<HomeCubit>(),
                builder: (BuildContext context, HomeCubitState state) {
                  if (state is HomeCubitLoadedState) {
                    return SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: DropdownButton(
                          hint: const Text('Please choose a Active Symbol'),
                          // Not necessary for Option 1
                          value: _selectedLocation,
                          onChanged: (ActiveSymbol? newValue) {
                            BlocManager.instance
                                .fetch<TickCubit>()
                                .getLivePrice(newValue!);
                            BlocManager.instance
                                .fetch<ContractCubit>()
                                .getAvailableContracts(newValue!);

                            setState(() {
                              _selectedLocation = newValue!;
                            });
                          },
                          items: state.activeSymbols!
                              .map((ActiveSymbol location) => DropdownMenuItem(
                                    child: Text(location != null
                                        ? location.symbol!
                                        : ''),
                                    value: location,
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  } else if (state is HomeCubitLoadingState) {
                    return const CircularProgressIndicator();
                  } else if (state is ActiveSymbolsError) {
                    return Text(state.message!);
                  } else {
                    return Container();
                  }
                  // state is HomeCubitLoadedState
                  //     ?
                }),
            const SizedBox(
              height: 16,
            ),
            Text(
                "Symbol Name: ${_selectedLocation != null ? _selectedLocation?.symbol ?? "" : ""}"),
            BlocBuilder<TickCubit, TicksCubitState>(
                bloc: BlocManager.instance.fetch<TickCubit>(),
                builder: (BuildContext context, TicksCubitState state) {
                  if (state is TicksLoaded) {
                    return Text('Price: ${state.tick.ask!.toStringAsFixed(5)}');
                  } else if (state is TicksLoading) {
                    return const Text('Price: ---');
                  } else if (state is TicksError) {
                    return Text(state.message);
                  } else {
                    return const Text('Price: ---');
                  }
                }),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
                width: double.infinity,
                child: Text(
                  'Available Contrats',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            BlocBuilder<ContractCubit, ContractCubitState>(
                bloc: BlocManager.instance.fetch<ContractCubit>(),
                builder: (BuildContext context, ContractCubitState state) {
                  if (state is AvailableContractsLoaded) {
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (BuildContext buildContext, int index) =>
                            Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Category :${state.contracts!.availableContracts![index]!.contractCategory!}'),
                            Text(
                                'Name :${state.contracts!.availableContracts![index]!.contractDisplay!}'),
                            Text(
                                'Market :${state.contracts!.availableContracts![index]!.market!}'),
                            Text(
                                'SubMarket :${state.contracts!.availableContracts![index]!.submarket!}'),
                          ],
                        ),
                        itemCount: state.contracts!.availableContracts!.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    );
                  } else if (state is ContractCubitLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContractError) {
                    return Text(state.message!);
                  } else {
                    return Container();
                  }
                })
          ],
        ),
      );
}
