// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/core/app/app_data.dart';
import 'package:shop_sphere_dashboard/features/orders/data/model/orer_model.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/entity/order_entity.dart';

import 'package:shop_sphere_dashboard/features/orders/domain/repo/order_repo.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/controller/order/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.orderRepo}) : super(OrderInitial());
  final OrderRepo orderRepo;
  OrderEntity? currentOrder;
  int currentStatus = 0;
  int currentTrackingNumber = 0;
  int currentOrderLength = 0;
  void changeOrderStatus(int index) async {
    currentStatus = index;
    await getUserOrders(status: orderStauts[index]);
  }

  Future<void> createOrder({required OrderModel order}) async {
    emit(CreateOrderLoading());
    final result = await orderRepo.craeteOrders(orderModel: order);
    result.fold(
      (l) async {
        emit(OrderError(error: l.message));
        await getUserOrders(status: orderStauts[currentStatus]);
      },
      (r) async {
        emit(CreateOrderSuccess());
        await getUserOrders(status: orderStauts[currentStatus]);
      },
    );
  }

  Future<void> getUserOrders({required String status}) async {
    emit(GetOrderLoading());
    final result = await orderRepo.getUserOrders(status: status);
    result.fold((l) => emit(GetOrderError(error: l.message)), (orders) {
      emit(OrderSuccess(orders: orders));
    });
  }

  Future<void> deletOrder({required OrderModel order}) async {
    emit(DeletOrderLoading());
    final result = await orderRepo.deletOrder(order: order);
    result.fold((l) => emit(OrderError(error: l.message)), (r) async {
      await getUserOrders(status: orderStauts[currentStatus]);
    });
  }

  Future<void> changeOrdeStatus({
    required String status,
    required String orderId,
    required int trackingNumber,
  }) async {
    emit(UpdateOrderLoading());
    final result = await orderRepo.changeOrdeStatus(
      status: status,
      orderId: orderId,
      trackingNumber: trackingNumber,
    );
    result.fold((l) => emit(OrderError(error: l.message)), (r) async {
      await getUserOrders(status: status);
    });
  }

  Future<void> getAllOrders() async {
    emit(GetOrderLoading());
    final result = await orderRepo.getAllOrders();
    result.fold(
      (l) => emit(OrderError(error: l.message)),
      (orders) => emit(OrderSuccess(orders: orders)),
    );
  }

  Future<void> getTrackinNumber() async {
    emit(GetOrderLoading());
    final result = await orderRepo.getTrackinNumber();
    result.fold(
      (l) {
        emit(OrderError(error: l.message));
      },
      (r) {
        emit(GetTrackingNumber(trackingNumber: r));
        currentTrackingNumber = r;
      },
    );
  }

  Future<void> getOrderLength() async {
    emit(GetOrderLoading());
    final result = await orderRepo.getOrderLength();
    result.fold((l) => emit(OrderError(error: l.message)), (length) {
      emit(GetOrderLength(orderLength: length));
      currentOrderLength = length;
    });
  }

  Future<void> getCustomerOrder({required String uId}) async {
    emit(GetOrderLoading());
    final result = await orderRepo.getCustomerOrder(uId: uId);
    result.fold(
      (l) => emit(OrderError(error: l.message)),
      (orders) => emit(OrderSuccess(orders: orders)),
    );
  }

  Future<void> getCustomerOrders({required String userId}) async {
    emit(CustomerOrdersLoading());
    final result = await orderRepo.getCustomerOrder(uId: userId);
    result.fold(
      (failure) => emit(CustomerOrdersFailure(error: failure.message)),
      (orders) => emit(CustomerOrdersSuccess(orders: orders)),
    );
  }

  Future<void> getOrderById({
    required String orderId,
    OrderEntity? initialOrder,
  }) async {
    if (orderId.isEmpty) {
      emit(OrderDetailsFailure(error: 'Order ID is required.'));
      return;
    }

    if (initialOrder != null) {
      currentOrder = initialOrder;
      emit(OrderDetailsSuccess(order: initialOrder));
      return;
    }

    emit(OrderDetailsLoading());
    final result = await orderRepo.getOrderById(orderId: orderId);
    result.fold(
      (failure) => emit(OrderDetailsFailure(error: failure.message)),
      (order) {
        currentOrder = order;
        emit(OrderDetailsSuccess(order: order));
      },
    );
  }
}
