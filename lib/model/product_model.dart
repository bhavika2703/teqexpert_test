class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  List<dynamic> imageUrl;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Product',
      description: json['description'] ?? 'Unknown Product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['images'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}
