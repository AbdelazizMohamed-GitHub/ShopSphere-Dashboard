import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_sphere_dashboard/core/service/firestore_service.dart';
import 'package:shop_sphere_dashboard/features/analytics/data/repo_impl/analytics_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/users/data/repo_impl/users_impl.dart';
import 'package:shop_sphere_dashboard/features/users/data/repo_impl/notification_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/orders/data/repo_impl/order_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/orders/data/repo_impl/address_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/orders/data/repo_impl/user_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/products/data/repo_impl/products_repo_impl.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register Firestore instance
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Register FirestoreService
  getIt.registerLazySingleton(
    () => FirestoreService(firestore: getIt<FirebaseFirestore>()),
  );

  // Register AuthRepo
  getIt.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(firestoreService: getIt<FirestoreService>()),
  );

  getIt.registerLazySingleton<UserRepoImpl>(
    () => UserRepoImpl(firestoreService: getIt<FirestoreService>()),
  );

  getIt.registerLazySingleton<OrderRepoImpl>(
    () => OrderRepoImpl(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<AddressRepoImpl>(
    () => AddressRepoImpl(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<ProductsRepoImpl>(
    () => ProductsRepoImpl(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<UsersRepoImpl>(
    () => UsersRepoImpl(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<NotificationRepoImpl>(
    () => NotificationRepoImpl(),
  );
  getIt.registerLazySingleton<AnalyticsRepoImpl>(
    () => AnalyticsRepoImpl(firestoreService: getIt<FirestoreService>()),
  );

  // Register Cubit
}
