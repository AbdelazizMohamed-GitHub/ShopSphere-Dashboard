
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

class CustomProductDetailsBody extends StatelessWidget {
  const CustomProductDetailsBody({super.key, required this.product, required this.tagId});
  final String tagId;
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.getHorizontalLargePadding(
      context,
    );
    final discountedPrice =
        product.price - (product.price * product.discount / 100);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: product.imageUrl.isEmpty
                ? const ColoredBox(
                    color: Colors.black12,
                    child: SizedBox(height: 300, width: double.infinity),
                  )
                : CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 16),
          Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
          Text(
            'Category: ${product.category}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (product.discount > 0)
                Text(
                  '${product.price.toStringAsFixed(2)} EGP',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '${discountedPrice.toStringAsFixed(2)} EGP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (product.discount > 0)
                Text(
                  ' (${product.discount}%)',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(product.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Stock: ${product.stock}', style: AppStyles.text18Regular),
              Text(
                'Staff: ${product.staffName}',
                style: AppStyles.text18Regular,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}