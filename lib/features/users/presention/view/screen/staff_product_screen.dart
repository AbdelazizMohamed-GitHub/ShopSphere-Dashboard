import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';

import 'package:shop_sphere_dashboard/features/products/presention/view/widget/custom_product_gride.dart';
import 'package:shop_sphere_dashboard/features/users/data/repo_impl/users_impl.dart';
import 'package:shop_sphere_dashboard/features/users/presention/controller/user_cubit/users_cubit.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StaffProductScreen extends StatelessWidget {
  const StaffProductScreen({super.key, required this.staffId});
  final String staffId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MangeUsersCubit(mangeUsersRepo: getIt<UsersRepoImpl>())
            ..getStaffProduct(staffId: staffId),
      child: BlocBuilder<MangeUsersCubit, MangeUsersState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Staff Product"),
              actions: [
                Text(
                  "Total: ${state is MangeStaffProductsSuccess ? state.products.length : 0}",
                ),
                const SizedBox(width: 15),
              ],
            ),
            body: BlocBuilder<MangeUsersCubit, MangeUsersState>(
              builder: (context, state) {
                if (state is MangeUsersFailure) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.errMessage, textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () => context
                              .read<MangeUsersCubit>()
                              .getStaffProduct(staffId: staffId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final isLoading =
                    state is MangeUsersLoading || state is MangeUsersInitial;
                final products = state is MangeStaffProductsSuccess
                    ? state.products
                    : List<ProductEntity>.generate(
                        8,
                        (_) => ProductEntity.empty(),
                      );
                return products.isEmpty && !isLoading
                    ? const Center(child: Text('No Products Found'))
                    : Skeletonizer(
                        enabled: isLoading,
                        child: CustomProductGrid(products: products),
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
