import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shop_sphere_dashboard/core/app/app_data.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_button.dart';
import 'package:shop_sphere_dashboard/core/widget/warning.dart';
import 'package:shop_sphere_dashboard/features/orders/data/model/orer_model.dart';
import 'package:shop_sphere_dashboard/features/orders/data/repo_impl/order_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/entity/order_entity.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/controller/order/order_cubit.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/controller/order/order_state.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/widget/custom_order_items.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/widget/custom_process_screen_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrdersDetailsScreen extends StatelessWidget {
  const OrdersDetailsScreen({
    super.key,
    required this.orderId,
    required this.order,
  });

  final String orderId;
  final OrderEntity? order;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderCubit(orderRepo: getIt<OrderRepoImpl>())
            ..getOrderById(orderId: orderId, initialOrder: order),
      child: Builder(builder: (context) => _OrderDetailsView(orderId: orderId)),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final horizontalPadding = ResponsiveLayout.getHorizontalLargePadding(
      context,
    );
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          Warning.showWarning(context, message: state.error, isError: true);
        } else if (state is OrderSuccess) {
          context.go(AppRoutes.orders);
        }
      },
      builder: (context, state) {
        if (state is OrderDetailsFailure) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Order Details'),
            ),
            body: _OrderFailure(
              message: state.error,
              onRetry: () =>
                  context.read<OrderCubit>().getOrderById(orderId: orderId),
            ),
          );
        }

        final cubit = context.read<OrderCubit>();
        final currentOrder = state is OrderDetailsSuccess
            ? state.order
            : cubit.currentOrder ?? OrderEntity.empty();
        final isLoading =
            state is OrderDetailsLoading ||
            (state is OrderInitial && cubit.currentOrder == null);

        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Order Details'),
                ),
          body: Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: _OrderDetailsContent(
                order: currentOrder,
                isLoading: isLoading,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  const _OrderDetailsContent({required this.order, required this.isLoading});

  final OrderEntity order;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CustomOrderItemDashboard(orderEntity: order),
            const Divider(height: 20),
            CustomProcessScreenItem(
              title: 'Order Date',
              subTitle: DateFormat.yMMMEd().format(order.orderDate),
            ),
            const Divider(height: 20),
            CustomProcessScreenItem(
              title: 'Tracking Number',
              subTitle: order.trackingNumber.toString(),
            ),
            const Divider(height: 20),
            CustomProcessScreenItem(
              title: 'Order Status',
              subTitle: order.status,
            ),
            const Divider(height: 20),
            CustomProcessScreenItem(
              title: 'Customer Name',
              subTitle: order.userName,
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Shipping Address', style: AppStyles.text18Regular),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    '${order.address.street}, ${order.address.city}, ${order.address.state}, ${order.address.phoneNumber}',
                    style: AppStyles.text14Regular.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (isLoading)
              const SizedBox(height: 90)
            else if (order.status == orderStauts[3])
              Text(
                'Order Delivered',
                style: AppStyles.text18Regular.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              _OrderActions(order: order),
          ],
        ),
      ),
    );
  }
}

class _OrderActions extends StatelessWidget {
  const _OrderActions({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final isDeleting = state is DeletOrderLoading;
        final isUpdating = state is UpdateOrderLoading;
        return Column(
          children: [
            CustomButton(
              onPressed: isDeleting || isUpdating
                  ? () {}
                  : () => context.read<OrderCubit>().deletOrder(
                      order: OrderModel.fromEntity(order),
                    ),
              text: isDeleting ? 'Cancelling...' : 'Cancel Order',
              color: Colors.white,
              textColor: Colors.black,
            ),
            const SizedBox(height: 20),
            if (order.status == orderStauts[1])
              CustomButton(
                onPressed: isUpdating
                    ? () {}
                    : () async {
                        final cubit = context.read<OrderCubit>();
                        await cubit.getTrackinNumber();
                        await cubit.changeOrdeStatus(
                          status: orderStauts[2],
                          orderId: order.orderId,
                          trackingNumber: cubit.currentTrackingNumber,
                        );
                      },
                text: isUpdating ? 'Updating...' : 'Process Order',
              )
            else
              CustomButton(
                onPressed: isUpdating
                    ? () {}
                    : () => context.read<OrderCubit>().changeOrdeStatus(
                        status: orderStauts[3],
                        orderId: order.orderId,
                        trackingNumber: order.trackingNumber,
                      ),
                text: isUpdating ? 'Updating...' : 'Deliver Order',
              ),
          ],
        );
      },
    );
  }
}

class _OrderFailure extends StatelessWidget {
  const _OrderFailure({required this.message, required this.onRetry});

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
