part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductLoadEvent extends ProductEvent {}

class ProductRetryEvent extends ProductEvent {}
