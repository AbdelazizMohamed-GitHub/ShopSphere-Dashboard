import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_sphere_dashboard/core/loading/custom_image_loading.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

class Customselectedproductcard extends StatelessWidget {
  const Customselectedproductcard({super.key, required this.product});
final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CustomImageLoading(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_not_supported_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text('Price: ${product.price}'),
                Text('Discount: ${product.discount}%'),
               
              ],
            ),
          ),
        ],
      ),
    );

}}