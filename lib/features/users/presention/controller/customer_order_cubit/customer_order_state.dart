import 'package:equatable/equatable.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/entity/address_entity.dart';

sealed class CustomerOrderState extends Equatable {
  const CustomerOrderState();

  @override
  List<Object?> get props => [];
}

final class CustomerAddressInitial extends CustomerOrderState {
  const CustomerAddressInitial();
}

final class CustomerAddressesLoading extends CustomerOrderState {
  const CustomerAddressesLoading();
}

final class CustomerAddressesSuccess extends CustomerOrderState {
  const CustomerAddressesSuccess({required this.addresses});

  final List<AddressEntity> addresses;

  @override
  List<Object?> get props => [addresses];
}

final class CustomerAddressesFailure extends CustomerOrderState {
  const CustomerAddressesFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
