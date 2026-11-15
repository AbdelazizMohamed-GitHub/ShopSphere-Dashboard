import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/core/theme/app_color.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_error_widget.dart';
import 'package:shop_sphere_dashboard/features/auth/domain/entity/user_entity.dart';
import 'package:shop_sphere_dashboard/features/orders/data/repo_impl/address_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/orders/data/repo_impl/order_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/controller/order/order_cubit.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/controller/order/order_state.dart';
import 'package:shop_sphere_dashboard/features/users/presention/controller/customer_order_cubit/customer_order_cubit.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/widget/custom-customer-details-header.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/widget/custom_address_card.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/widget/custom_order_card.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key, required this.customer});

  final UserEntity customer;

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  late final CustomerAddressCubit _customerAddressCubit;
  late final OrderCubit _orderCubit;

  @override
  void initState() {
    super.initState();
    _customerAddressCubit = CustomerAddressCubit(
      addressRepo: getIt<AddressRepoImpl>(),
    )..getCustomerAddresses(userId: widget.customer.uid);
    _orderCubit = OrderCubit(orderRepo: getIt<OrderRepoImpl>())
      ..getCustomerOrder(uId: widget.customer.uid);
  }

  @override
  void dispose() {
    _customerAddressCubit.close();
    _orderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _customerAddressCubit  ),
        BlocProvider.value(value: _orderCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Customer Profile'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:ResponsiveLayout.getHorizontalLargePadding(context)),
                child: CustomCustomerDetailsHeader(customer: widget.customer),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final panelWidth = constraints.maxWidth >= 664
                      ? (constraints.maxWidth - 24) / 2
                      : 320.0;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: panelWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Saved addresses',
                                style: AppStyles.text22SemiBold,
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<
                                CustomerAddressCubit,
                                CustomerOrderState
                              >(
                                builder: (context, state) {
                                  if (state is CustomerAddressesLoading ||
                                      state is CustomerAddressInitial) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (state is CustomerAddressesFailure) {
                                    return CustomErrorWidget(
                                      errorMessage: state.message,
                                      onpressed: () => _customerAddressCubit
                                          .getCustomerAddresses(
                                            userId: widget.customer.uid,
                                          ),
                                    );
                                  }
                                  if (state is CustomerAddressesSuccess) {
                                    return state.addresses.isEmpty
                                        ? const Text('No saved addresses.')
                                        : Column(
                                            children: state.addresses
                                                .map(
                                                  (address) =>
                                                      CustomAddressCard(
                                                        address: address,
                                                      ),
                                                )
                                                .toList(),
                                          );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: panelWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Orders',
                                style: AppStyles.text22SemiBold,
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<OrderCubit, OrderState>(
                                builder: (context, state) {
                                  if (state is OrderSuccess) {
                                    return state.orders.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Text('No orders found.'),
                                          )
                                        : Column(
                                            children: state.orders
                                                .map(
                                                  (order) => CustomOrderCard(
                                                    order: order,
                                                  ),
                                                )
                                                .toList(),
                                          );
                                  }
                                  if (state is GetOrderLoading) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (state is OrderError) {
                                    return CustomErrorWidget(
                                      errorMessage: state.error,
                                      onpressed: () {
                                        _orderCubit.getCustomerOrder(
                                          uId: widget.customer.uid,
                                        );
                                      },
                                    );
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Orders are not available.'),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
