import 'package:dartz/dartz.dart';
import 'package:shop_sphere_dashboard/core/errors/fairebase_failure.dart';

abstract class NotificationRepo {
  Future<Either<FirebaseFailure, String>> addNotification({
    required String title,
    required String body,
    required String token,
    String? productId,
    String? imageUrl,
  });
}
