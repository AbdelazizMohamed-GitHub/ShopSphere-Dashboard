// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:shop_sphere_dashboard/core/widget/custom_dashboard_product_item.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

class CustomProductGrid extends StatelessWidget {
  const CustomProductGrid({super.key, required this.products});
  final List<ProductEntity> products;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 600 ? 16.0 : 12.0;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 5 / 6,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomDashboardProductItem(product: products[index]);
          },
        );
      },
    );
  }
}
