import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/get_unit_cubit.dart';

class UnitDataView extends StatefulWidget {
  const UnitDataView({super.key});

  @override
  State<UnitDataView> createState() => _UnitDataViewState();
}

class _UnitDataViewState extends State<UnitDataView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GetUnitCubit>().fetchData();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<GetUnitCubit>().fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data'),
      ),
      body: BlocListener<GetUnitCubit, GetUnitState>(
        listener: (context, state) {
          if (state is GetLoadingState &&
              context.read<GetUnitCubit>().items.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('More data loaded successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<GetUnitCubit, GetUnitState>(
          builder: (context, state) {
            if (state is GetLoadingState &&
                context.read<GetUnitCubit>().items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetSuccessState) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<GetUnitCubit>()
                      .fetchData(isRefreshData: true);
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: context.read<GetUnitCubit>().items.length +
                      (state.moreDate ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == context.read<GetUnitCubit>().items.length) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ));
                    }
                    final unitData = context.read<GetUnitCubit>().items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(unitData['id'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(unitData['name']),
                          Text(unitData['unitType']),
                          Text(unitData['address']),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (state is GetErrorState) {
              return Center(
                child: Text(state.message),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
