import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity__event.dart';
part 'connectivity__state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<ConnectivityChangedEvent>(_onConnectivityChanged);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (resultList) {
        add(ConnectivityChangedEvent(resultList));
      },
    );
  }

  void _onConnectivityChanged(
      ConnectivityChangedEvent event, Emitter<ConnectivityState> emit) {
    if (event.result == ConnectivityResult.none) {
      emit(ConnectivityOffline());
    } else {
      emit(ConnectivityOnline());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
