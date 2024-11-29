import 'dart:developer';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String price;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Extract images and log them
    List<String> extractedImages = [];
    if (json['images'] is List) {
      extractedImages = (json['images'] as List)
          .where((image) => image is String && image.isNotEmpty)
          .cast<String>()
          .toList();

      // Log images for debugging
      log('Product Images: $extractedImages', name: 'ProductModel');
    }

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unnamed Product',
      description: json['description'] ?? 'No description',
      price: (json['price'] ?? 0).toString(),
      images: extractedImages,
    );
  }

  String get firstImageUrl => images.isNotEmpty ? images.first : '';
}