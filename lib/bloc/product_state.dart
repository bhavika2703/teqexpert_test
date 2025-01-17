part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {
  final List<Product> products;
  ProductSuccessState(this.products);
}

class ProductErrorState extends ProductState {
  final String errorMessage;
  ProductErrorState(this.errorMessage);
}

class ProductNoDataState extends ProductState {}

class ProductInternetErrorState extends ProductState {}
