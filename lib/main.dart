import 'package:deriv_go_app/screens/home/home.dart';
import 'package:deriv_go_app/state/available_contract/contract_cubit.dart';
import 'package:deriv_go_app/state/home/home_cubit.dart';
import 'package:deriv_go_app/state_emitter/home_cubit_state_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_deriv_api/state/connection/connection_cubit.dart'
as api_connection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/base_bloc_manager.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';
import 'package:flutter_deriv_bloc_manager/event_dispatcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sample Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late api_connection.ConnectionCubit _connectionCubit;

  @override
  void initState() {
    super.initState();
    initializeBlocs();
    _connectionCubit = api_connection.ConnectionCubit(
      ConnectionInformation(
        appId: '1089',
        brand: 'binary',
        endpoint: 'frontend.binaryws.com',
      ),
    );
  }

  @override
  void dispose() {
    _connectionCubit.close();

    super.dispose();
  }
  void initializeBlocs() {
    // Register Blocs.
    BlocManager.instance.register(HomeCubit());
    BlocManager.instance.register(ContractCubit());

    // Register State Emitters.
    EventDispatcher(BlocManager.instance)
       .register<HomeCubit, HomeCubitStateEmitter>(
          (BaseBlocManager blocManager) => HomeCubitStateEmitter(blocManager));
       // ..register<ContractCubit>(
       //    (BaseBlocManager blocManager) => HomeCubitStateEmitter(blocManager));



  }
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<api_connection.ConnectionCubit>.value(
        value: _connectionCubit,
      ),
    ],
    child: Scaffold(
      appBar: AppBar(
        title: const Text('API Sample App'),
      ),
      body: BlocBuilder<api_connection.ConnectionCubit,
          api_connection.ConnectionState>(
        builder: (
            BuildContext context,
            api_connection.ConnectionState state,
            ) {

          if (state is api_connection.ConnectionConnectedState) {
            // Call a function in the [MainCubit] to emit an event.
            BlocManager.instance.fetch<HomeCubit>().getActiveSymbol();
           return const HomePage();
          } else if (state is api_connection.ConnectionInitialState ||
              state is api_connection.ConnectionConnectingState) {
            return _buildCenterText('Loading...');
          } else if (state is api_connection.ConnectionErrorState) {
            return _buildCenterText('Loading Error\n${state.error}');
          } else if (state is api_connection.ConnectionDisconnectedState) {
            return _buildCenterText(
              'Connection is down, trying to reconnect...',
            );
          }

          return Container();
        },
      ),
    ),
  );

  Widget _buildCenterText(String text) => Center(
    child: Column(
      children: [
        Text(text),
        const CircularProgressIndicator()
      ],
    ),
  );
}
