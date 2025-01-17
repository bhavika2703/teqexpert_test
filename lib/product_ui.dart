import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teq_expert_test/bloc/product_bloc.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductSuccessState) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                String imageUrl = product.imageUrl.isNotEmpty
                    ? product.imageUrl[0]
                    : product.thumbnail;

                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        product.id.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Handle image loading gracefully
                      imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : const Icon(Icons.image_not_supported, size: 50),
                      Text(
                        product.description ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Price: \$${product.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey.shade300),
                    ],
                  ),
                );
              },
            );
          } else if (state is ProductErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.errorMessage),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(ProductRetryEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Container(); // Default fallback
        },
      ),
    );
  }
}
