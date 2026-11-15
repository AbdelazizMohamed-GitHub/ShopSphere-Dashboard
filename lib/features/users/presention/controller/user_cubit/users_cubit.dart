import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/features/auth/domain/entity/user_entity.dart';
import 'package:shop_sphere_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

part 'users_state.dart';

class MangeUsersCubit extends Cubit<MangeUsersState> {
  MangeUsersCubit({required this.mangeUsersRepo}) : super(MangeUsersInitial());
  final UsersRepo mangeUsersRepo;

  Future<void> getUsers({required bool isStaff}) async {
    emit(MangeUsersLoading());
    final result = await mangeUsersRepo.getUsers(isStaff: isStaff);
    result.fold(
      (l) => emit(MangeUsersFailure(errMessage: l.message)),
      (users) => emit(MangeUsersSuccess(users: users)),
    );
  }

  Future<void> getStaffProducts({required String staffId}) async {
    emit(MangeUsersLoading());
    final result = await mangeUsersRepo.getStaffProducts(staffId: staffId);
    result.fold(
      (l) => emit(MangeUsersFailure(errMessage: l.message)),
      (products) => emit(MangeStaffProductsSuccess(products: products)),
    );
  }

  Future<void> getStaffProduct({required String staffId}) {
    return getStaffProducts(staffId: staffId);
  }

  Future<void> changeUserRule({
    required String userId,
    required bool isStaff,
  }) async {
    emit(MangeUsersLoading());
    final result = await mangeUsersRepo.changeUserRule(
      userId: userId,
      isStaff: isStaff,
    );
    result.fold(
      (l) => emit(MangeUsersFailure(errMessage: l.message)),
      (_) => getUsers(isStaff: !isStaff),
    );
  }
}
