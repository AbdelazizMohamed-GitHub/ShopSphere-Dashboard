import 'package:shop_sphere_dashboard/features/orders/data/model/cart_model.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/entity/address_entity.dart';

class OrderEntity {
  final String uId;
  final String orderId;
  final String userName;
  final double totalAmount;
  final List<CartItemModel> items;
  final String status;
  final DateTime orderDate;
  final AddressEntity address;
  final String paymentMethod;
  final int delivaryCoast;
  final int trackingNumber;

  OrderEntity({
    required this.uId,
    required this.userName,
    required this.address,
    required this.orderId,
    required this.totalAmount,
    required this.items,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    required this.delivaryCoast,
    required this.trackingNumber,
  });

  factory OrderEntity.empty() => OrderEntity(
    uId: '',
    orderId: '',
    userName: '',
    totalAmount: 0,
    items: const [],
    status: '',
    orderDate: DateTime(2000),
    address: AddressEntity(
      id: '',
      title: '',
      phoneNumber: '',
      street: '',
      city: '',
      state: '',
      country: '',
      postalCode: '',
    ),
    paymentMethod: '',
    delivaryCoast: 0,
    trackingNumber: 0,
  );
}
