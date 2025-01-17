import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:teq_expert_test/model/product_model.dart';

class ProductRepository {
  final String apiUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['products'] as List;
        print('data ::: : $data');

        // Parse JSON into Product models
        return data
            .map((productJson) => Product.fromJson(productJson))
            .toList();
      } else {
        throw Exception(
            'Failed to load products. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}
