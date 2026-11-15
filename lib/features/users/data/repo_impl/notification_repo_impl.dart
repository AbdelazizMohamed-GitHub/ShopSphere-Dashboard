import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_sphere_dashboard/core/errors/fairebase_failure.dart';
import 'package:shop_sphere_dashboard/core/service/notification_service.dart';
import 'package:shop_sphere_dashboard/features/users/data/model/notification_model.dart';
import 'package:shop_sphere_dashboard/features/users/domain/repo/notification_repo.dart';

class NotificationRepoImpl extends NotificationRepo {
  @override
  Future<Either<FirebaseFailure, String>> addNotification({
    required String title,
    required String body,
    required String token,
    String? productId,
    String? imageUrl,
  }) async {
    try {
      await NotificationService.sendNotification(
        notification: NotificationModel(
          title: title,
          description: body,
          date: DateTime.now(),
          productId: productId,
          imageUrl: imageUrl,
        ),
        token: token,
      );
      return right("Notification sent successfully");
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromCode(e.code));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
