import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:shop_sphere_dashboard/core/errors/fairebase_failure.dart';
import 'package:shop_sphere_dashboard/core/service/firestore_service.dart';
import 'package:shop_sphere_dashboard/features/orders/data/model/addres_model.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/entity/address_entity.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/repo/address_repo.dart';

class AddressRepoImpl extends AddressRepo {
  AddressRepoImpl({required this.firestoreService});

  final FirestoreService firestoreService;

  @override
  Future<Either<FirebaseFailure, void>> addAddress(
    String addressId,
    AddressModel addressModel,
  ) async {
    try {
      await firestoreService.addAddress(
        addressId: addressId,
        address: addressModel,
      );
      return right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailure.fromCode(error.code));
    } catch (error) {
      return Left(FirebaseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateAddress(
    String addressId,
    AddressModel addressModel,
  ) async {
    try {
      await firestoreService.updateAddress(
        addressId: addressId,
        address: addressModel,
      );
      return right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailure.fromCode(error.code));
    } catch (error) {
      return Left(FirebaseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> deleteAddress(String addressId) async {
    try {
      await firestoreService.deleteAddress(addressId: addressId);
      return right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailure.fromCode(error.code));
    } catch (error) {
      return Left(FirebaseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<AddressEntity>>> getAddress() async {
    try {
      return right(await firestoreService.getAddresses());
    } on FirebaseException catch (error) {
      return Left(FirebaseFailure.fromCode(error.code));
    } catch (error) {
      return Left(FirebaseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<AddressEntity>>> getCustomerAddresses({
    required String userId,
  }) async {
    try {
      return right(await firestoreService.getAddresses(userId: userId));
    } on FirebaseException catch (error) {
      return Left(FirebaseFailure.fromCode(error.code));
    } catch (error) {
      return Left(FirebaseFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<FirebaseFailure, void>> updateAddressIndex({
    required int sellectAddress,
  }) async {
    try {
      await firestoreService.updateAddressIndex(
        selectedAddress: sellectAddress,
      );
      return right(null);
    } on FirebaseException catch (error) {
      return Left(FirebaseFailure.fromCode(error.code));
    } catch (error) {
      return Left(FirebaseFailure(message: error.toString()));
    }
  }
}
