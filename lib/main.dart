import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teq_expert_test/product_ui.dart';
import 'package:teq_expert_test/repo.dart';
import 'package:teq_expert_test/unit_data.dart';

import 'bloc/connectivity/connectivity__bloc.dart';
import 'bloc/get_unit_cubit.dart';
import 'bloc/product_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(ProductRepository()),
        ),
        BlocProvider(
          create: (context) => ConnectivityBloc(Connectivity()),
        ),
        BlocProvider(create: (context) => GetUnitCubit())
      ],
      child: MaterialApp(
        title: 'Flutter teqExpert',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const UnitDataView(),
      ),
    );
  }
}
