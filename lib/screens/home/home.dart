import 'package:deriv_go_app/state/available_contract/contract_cubit.dart';
import 'package:deriv_go_app/state/home/home_cubit.dart';
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
  List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
  ActiveSymbol? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
              width: double.infinity,
              child: Text(
                "Active Symbol",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          BlocBuilder<HomeCubit, HomeCubitState>(
              bloc: BlocManager.instance.fetch<HomeCubit>(),
              builder: (context, state) {
                return state is HomeCubitLoadedState
                    ? SizedBox(width: double.infinity,
                      child: Center(
                        child: DropdownButton(
                            hint: const Text('Please choose a Active Symbol'),
                            // Not necessary for Option 1
                            value: _selectedLocation,
                            onChanged: (ActiveSymbol? newValue) {
                              BlocManager.instance
                                  .fetch<ContractCubit>()
                                  .getAvailableContracts(newValue!);
                              setState(() {
                                _selectedLocation = newValue!;
                              });
                            },
                            items: (state).activeSymbols!.map((location) {
                              return DropdownMenuItem(
                                child:
                                    Text(location != null ? location.symbol! : ""),
                                value: location,
                              );
                            }).toList(),
                          ),
                      ),
                    )
                    : const CircularProgressIndicator();
              }),
          const SizedBox(
            height: 16,
          ),
          Text(
              "Symbol Name: ${_selectedLocation != null ? _selectedLocation?.symbol ?? "" : ""}"),
          Text(
              "Price: ${_selectedLocation != null ? _selectedLocation?.pip ?? "" : ""}"),
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
              width: double.infinity,
              child: Text(
                "Available Contrats",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          BlocBuilder<ContractCubit, ContractCubitState>(
              bloc: BlocManager.instance.fetch<ContractCubit>(),
              builder: (context, state) {
                if (state is AvailableContractsLoaded) {
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (buildcontext, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Category :${(state).contracts!.availableContracts![index]!.contractCategory!}"),
                            Text(
                                "Name :${(state).contracts!.availableContracts![index]!.contractDisplay!}"),
                            Text(
                                "Market :${(state).contracts!.availableContracts![index]!.market!}"),
                            Text(
                                "SubMarket :${(state).contracts!.availableContracts![index]!.submarket!}"),
                          ],
                        );
                      },
                      itemCount: (state).contracts!.availableContracts!.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  );
                } else if (state is ContractCubitLoadingState) {
                  return Center(child: const CircularProgressIndicator());
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
}
