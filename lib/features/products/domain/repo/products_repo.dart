import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:shop_sphere_dashboard/core/errors/fairebase_failure.dart';
import 'package:shop_sphere_dashboard/features/products/data/model/product_model.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

abstract class ProductsRepo {
  Future<Either<FirebaseFailure, String>> addProduct({
    required ProductModel product,
    required Uint8List imageFile,
  });

  Future<Either<FirebaseFailure, List<ProductEntity>>> getProducts({
    required String category,
  });

  Future<Either<FirebaseFailure, ProductEntity>> getProductById({
    required String productId,
  });

  Future<Either<FirebaseFailure, String>> deleteProduct({
    required String dId,
    required String imageUrl,
  });

  Future<Either<FirebaseFailure, String>> updateProduct({
    required ProductModel data,
  });
}
