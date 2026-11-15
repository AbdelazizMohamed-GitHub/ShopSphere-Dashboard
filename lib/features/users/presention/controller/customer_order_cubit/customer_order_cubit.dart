import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/repo/address_repo.dart';
import 'package:shop_sphere_dashboard/features/users/presention/controller/customer_order_cubit/customer_order_state.dart';

export 'package:shop_sphere_dashboard/features/users/presention/controller/customer_order_cubit/customer_order_state.dart';

class CustomerAddressCubit extends Cubit<CustomerOrderState> {
  CustomerAddressCubit({required this.addressRepo})
    : super(const CustomerAddressInitial());

  final AddressRepo addressRepo;

  Future<void> getCustomerAddresses({required String userId}) async {
    if (userId.trim().isEmpty) {
      emit(const CustomerAddressesFailure(message: 'Customer ID is required.'));
      return;
    }

    emit(const CustomerAddressesLoading());
    final result = await addressRepo.getCustomerAddresses(userId: userId);
    result.fold(
      (failure) => emit(CustomerAddressesFailure(message: failure.message)),
      (addresses) => emit(CustomerAddressesSuccess(addresses: addresses)),
    );
  }
}
