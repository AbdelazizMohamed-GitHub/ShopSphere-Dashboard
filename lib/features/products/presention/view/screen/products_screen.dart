import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_dashboard_product_item.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_error_widget.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/products/data/repo_impl/products_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_cubit.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsCubit(productsRepo: getIt<ProductsRepoImpl>())..getProducts(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  final productCount = state is GetProductsSuccess
                      ? ' (${state.products.length})'
                      : '';
                  return Text('Products$productCount');
                },
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.pushNamed('addProduct'),
              icon: const Icon(Icons.add),
              label: const Text('Add product'),
            ),
            body: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsFailer) {
                  return CustomErrorWidget(
                    errorMessage: state.errMessage,
                    onpressed: () async {
                      await context.read<ProductsCubit>().getProducts();
                    },
                  );
                }

                final isLoading =
                    state is ProductsLoading || state is ProductsInitial;
                final products = state is GetProductsSuccess
                    ? state.products
                    : List<ProductEntity>.generate(
                        10,
                        (_) => ProductEntity.empty(),
                      );

                return Skeletonizer(
                  enabled: isLoading,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveLayout.getCrossAxisCount(
                        context,
                      ),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return CustomDashboardProductItem(
                        product: products[index],
                      );
                    },
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
