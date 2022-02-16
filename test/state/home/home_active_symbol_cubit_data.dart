import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter_deriv_api/api/common/active_symbols/active_symbols.dart';
import 'package:flutter_deriv_api/api/contract/contracts_for/contracts_for_symbol.dart';
import 'package:flutter_deriv_api/api/contract/models/available_contract_model.dart';

final List<ActiveSymbol> activeSymbols = <ActiveSymbol>[
  ActiveSymbol(
    isTradingSuspended: false,
    market: 'forex',
    marketDisplayName: 'Forex',
    pip: 0.001,
    submarket: 'smart_fx',
    submarketDisplayName: 'Smart FX',
    symbol: 'WLDAUD',
    symbolType: 'smart_fx',
  )
];

final List<Asset> assets = <Asset>[
  Asset(
    market: 'forex',
    marketDisplayName: 'Forex',
    subMarket: 'smart_fx',
    subMarketDisplayName: 'Smart FX',
    name: 'WLDAUD',
  )
];

final List<AvailableContractModel> contractsForSymbol = <AvailableContractModel>[
  AvailableContractModel(
      barrierCategory: 'euro_atm',
      barriers: 0,
      contractCategory: 'callput',
      contractCategoryDisplay: 'Up/Down',
      contractDisplay: 'Higher',
      contractType: 'CALL',
      exchangeName: 'FOREX',
      expiryType: 'daily',
      market: 'forex',
      maxContractDuration: '365d',
      minContractDuration: '1d',
      sentiment: 'up',
      startType: 'spot',
      submarket: 'major_pairs',
      underlyingSymbol: 'frxAUDJPY')
];
