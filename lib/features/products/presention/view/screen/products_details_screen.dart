import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_button.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_circle_button.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_error_widget.dart';
import 'package:shop_sphere_dashboard/core/widget/warning.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/products/data/repo_impl/products_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_cubit.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_state.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/widget/customproductdetailsbody.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.tagId,
    required this.product,
    required this.pId,
  });
  final String pId;
  final String tagId;
  final ProductEntity? product;

  @override
  build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.getHorizontalLargePadding(
      context,
    );
    return BlocProvider(
      create: (_) =>
          ProductsCubit(productsRepo: getIt<ProductsRepoImpl>())
            ..getProductById(productId: pId, initialProduct: product),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductsSuccess) {
            context.go(AppRoutes.products);
          } else if (state is ProductsFailer) {
            Warning.showWarning(
              context,
              message: state.errMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state is ProductDetailsFailure) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Details'),
              ),
              body: CustomErrorWidget(
                errorMessage: state.errMessage,
                onpressed: () {
                  context.read<ProductsCubit>().getProductById(productId: pId);
                },
              ),
            );
          }

          final product = state is ProductDetailsSuccess
              ? state.product
              : context.read<ProductsCubit>().currentProduct ??
                    ProductEntity.empty();
          final isLoading =
              state is ProductDetailsLoading ||
              (state is ProductsInitial && product.pId.isEmpty);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Details'),
              actions: [
                if (!isLoading && product.pId.isNotEmpty)
                  CustomCircleButton(
                    icon: const Icon(Icons.edit, size: 25),
                    funcation: () => context.pushNamed(
                      'updateProduct',
                      pathParameters: {'id': product.pId},
                    ),
                  ),
                const SizedBox(width: 20),
              ],
            ),
            body: Skeletonizer(
              enabled: isLoading,
              child: CustomProductDetailsBody(product: product, tagId: tagId),
            ),
            bottomNavigationBar: isLoading || product.pId.isEmpty
                ? null
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16,
                    ),
                    child: CustomButton(
                      onPressed: state is ProductsLoading
                          ? null
                          : () => context.read<ProductsCubit>().deleteProduct(
                              dId: product.pId,
                              imageUrl: product.imageUrl,
                            ),
                      text: state is ProductsLoading
                          ? 'Deleting...'
                          : state is ProductsFailer
                          ? 'Retry'
                          : 'Delete',
                    ),
                  ),
          );
        },
      ),
    );
  }
}
