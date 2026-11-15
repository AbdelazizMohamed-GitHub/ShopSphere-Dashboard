import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/loading/custom_image_loading.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

class CustomDashboardProductItem extends StatelessWidget {
  const CustomDashboardProductItem({super.key, required this.product});
  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: product.pId.isEmpty
          ? null
          : () {
              // Use pushNamed so browser back returns to the previous dashboard
              // instance instead of reloading/rebuilding the whole dashboard route.
              context.pushNamed(
                'productDetails',
                pathParameters: {'pId': product.pId},
                extra: product,
              );
            },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
                  placeholder: (context, url) => const CustomImageLoading(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppStyles.text14Regular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$ ${product.price}', style: AppStyles.text14Bold),
                      const Spacer(),
                      Text(
                        '${product.stock} Stock',
                        style: AppStyles.text12Regular,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text('Add By ', style: AppStyles.text12Bold),
                  Text(
                    maxLines: 1,
                    product.staffName,
                    overflow: TextOverflow.fade,
                    style: AppStyles.text12Regular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
