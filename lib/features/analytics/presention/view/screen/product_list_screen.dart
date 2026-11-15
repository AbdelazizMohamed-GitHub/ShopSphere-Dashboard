import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/features/analytics/data/model/product_most_seller_model.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/custom_most_sold_product_item.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key, required this.products});

  final List<ProductMostSellerModel> products;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.getHorizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Most Sold Products'),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products found.'))
          : LayoutBuilder(
              builder: (context, constraints) {
                if (!kIsWeb) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12,
                    ),
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        CustomMostSoldProductItem(product: products[index]),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(horizontalPadding),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    
                    
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) => CustomMostSoldProductItem(
                    product: products[index],
                    isGrid: true,
                  ),
                );
              },
            ),
    );
  }
}
