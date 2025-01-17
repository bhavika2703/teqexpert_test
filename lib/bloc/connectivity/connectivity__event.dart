part of 'connectivity__bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChangedEvent extends ConnectivityEvent {
  final ConnectivityResult result;

  const ConnectivityChangedEvent(this.result);

  @override
  List<Object> get props => [result];
}
