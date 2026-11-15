import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/loading/custom_image_loading.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/features/analytics/data/model/product_most_seller_model.dart';

class CustomMostSoldProductItem extends StatelessWidget {
  const CustomMostSoldProductItem({
    super.key,
    required this.product,
    this.isGrid = false,
  });

  final ProductMostSellerModel product;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: product.productImageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CustomImageLoading(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );

    if (isGrid) {
      return Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: InkWell(
          onTap: () => context.pushNamed(
            'productDetails',
            pathParameters: {'pId': product.productId},
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: image),
              Padding(
                padding: const EdgeInsets.all(14),
                child: _ProductDetails(product: product, showName: true),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: ListTile(
        onTap: () => context.pushNamed(
          'productDetails',
          pathParameters: {'pId': product.productId},
        ),
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(height: 60, width: 60, child: image),
        title: Text(
          product.productName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.text18Regular,
        ),
        subtitle: _ProductDetails(product: product),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({required this.product, this.showName = false});

  final ProductMostSellerModel product;
  final bool showName;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showName) ...[
        Text(
          product.productName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.text18Regular,
        ),
        const SizedBox(height: 6),
      ],
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: 'Count: ', style: AppStyles.text16Regular),
            TextSpan(
              text: '${product.productCount}',
              style: AppStyles.text16Bold,
            ),
            const TextSpan(text: '   '),
            TextSpan(text: 'Price: ', style: AppStyles.text16Regular),
            TextSpan(
              text: '${product.productPrice.toStringAsFixed(2)} EGP',
              style: AppStyles.text16Bold,
            ),
          ],
        ),
      ),
    ],
  );
}
