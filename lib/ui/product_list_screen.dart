import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/product_controller.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Catalog'),
      ),
      body: Consumer<ProductController>(
        builder: (context, productController, child) {
          if (productController.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (productController.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(
                    productController.errorMessage!,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => productController.fetchProducts(),
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: _buildProductImage(product.firstImageUrl),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${product.price}',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        child: Icon(Icons.image_not_supported),
        backgroundColor: Colors.grey[200],
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      errorWidget: (context, url, error) {
        print('Image load error: $error for URL: $url');
        return CircleAvatar(
          child: Icon(Icons.error_outline),
          backgroundColor: Colors.red[100],
        );
      },
    );
  }
}