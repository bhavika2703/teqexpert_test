part of 'get_unit_cubit.dart';

@immutable
sealed class GetUnitState {}

final class GetUnitInitial extends GetUnitState {}

final class GetLoadingState extends GetUnitState {}

final class GetSuccessState extends GetUnitState {
  final data;
  bool moreDate;

  GetSuccessState(this.data, this.moreDate);
}

class GetErrorState extends GetUnitState {
  final String message;

  GetErrorState(this.message);
}
