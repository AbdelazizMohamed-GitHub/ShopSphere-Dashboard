import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/products/data/repo_impl/products_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_cubit.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_state.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/widget/custom_product_gride.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsSearchResult extends StatelessWidget {
  const ProductsSearchResult({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductsCubit(productsRepo: getIt<ProductsRepoImpl>())
            ..searchProducts(query: query),
      child: Builder(
        builder: (context) {
          final isDesktop = ResponsiveLayout.isDesktop(context);
          return Scaffold(
            appBar: isDesktop
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
                    title: const Text('Search Results'),
                  ),
            body: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsFailer) {
                  return _SearchFailure(
                    message: state.errMessage,
                    onRetry: () => context.read<ProductsCubit>().searchProducts(
                      query: query,
                    ),
                  );
                }

                final isLoading =
                    state is ProductsLoading || state is ProductsInitial;
                final products = state is ProductsSearchSuccess
                    ? state.products
                    : List<ProductEntity>.generate(
                        8,
                        (_) => ProductEntity.empty(),
                      );

                return Skeletonizer(
                  enabled: isLoading,
                  child: products.isEmpty && !isLoading
                      ? const Center(child: Text('No products found'))
                      : SingleChildScrollView(
                          child: CustomProductGrid(products: products),
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SearchFailure extends StatelessWidget {
  const _SearchFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
