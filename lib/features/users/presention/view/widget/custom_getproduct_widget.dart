import 'package:flutter/material.dart';
import 'package:shop_sphere_dashboard/core/service/firestore_service.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

class CustomGetproductWidget extends StatefulWidget {
  const CustomGetproductWidget({super.key, required this.selectedProduct});
  final ValueChanged<ProductEntity?> selectedProduct;

  @override
  State<CustomGetproductWidget> createState() => _CustomGetproductWidgetState();
}

class _CustomGetproductWidgetState extends State<CustomGetproductWidget> {
  late Future<List<ProductEntity>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<ProductEntity>> _loadProducts() async =>
      getIt<FirestoreService>().gettProducts(category: 'All');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductEntity>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Could not load products: ${snapshot.error}'),
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.selectedProduct(null);
                    _productsFuture = _loadProducts();
                  });
                },
                child: const Text('Retry'),
              ),
            ],
          );
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const Text('No products available.');
        }

        return DropdownButtonFormField<ProductEntity>(
          initialValue: null,
          isExpanded: true,
          decoration: const InputDecoration(
            hintText: 'Choose product',
            border: OutlineInputBorder(),
          ),
          validator: (product) =>
              product == null ? 'Please select a product' : null,
          items: products
              .map(
                (product) => DropdownMenuItem<ProductEntity>(
                  value: product,
                  child: Text(product.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (product) {
            widget.selectedProduct(product);
          },
        );
      },
    );
  }
}
