import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teq_expert_test/repo.dart';

import '../model/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductLoadingState()) {
    on<ProductLoadEvent>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
      ProductLoadEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      final products = await productRepository.fetchProducts();
      if (products.isEmpty) {
        emit(ProductNoDataState());
      } else {
        emit(ProductSuccessState(products));
      }
    } catch (e) {
      if (e.toString().contains('No internet connection')) {
        emit(ProductInternetErrorState());
      } else {
        emit(ProductErrorState(e.toString()));
      }
    }
  }
}
