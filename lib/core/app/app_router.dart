import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/firestore_service.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/widget/warning.dart';
import 'package:shop_sphere_dashboard/features/auth/presention/view/screen/forget_password_screen.dart';
import 'package:shop_sphere_dashboard/features/auth/presention/view/screen/login_screen.dart';
import 'package:shop_sphere_dashboard/features/auth/presention/view/screen/register_screen.dart';
import 'package:shop_sphere_dashboard/features/onboarding/presention/view/screen/get_started_screen.dart';
import 'package:shop_sphere_dashboard/features/auth/domain/entity/user_entity.dart';
import 'package:shop_sphere_dashboard/features/analytics/data/model/product_most_seller_model.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/screen/dashboard_layout.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/screen/analytics_screen.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/screen/product_list_screen.dart';
import 'package:shop_sphere_dashboard/features/onboarding/presention/view/screen/onboarding_screen.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/orders/domain/entity/order_entity.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/view/screen/orders_details.dart';
import 'package:shop_sphere_dashboard/features/orders/presention/view/screen/orders_screen.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/screen/add_product_screen.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/screen/products_details_screen.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/screen/products_screen.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/screen/products_search_result.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/screen/search_screen.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/screen/add_notification_screen.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/screen/customer_screen.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/screen/staff_product_screen.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/screen/users_screen.dart';

ProductEntity? _productFromExtra(Object? extra) => switch (extra) {
  ProductEntity product => product,
  _ => null,
};

OrderEntity? _orderFromExtra(Object? extra) => switch (extra) {
  OrderEntity order => order,
  _ => null,
};

String _notificationTokenFromExtra(Object? extra) =>
    extra is String ? extra : '';
GoRouter router = GoRouter(
  initialLocation: '/role-check',
  routes: [
    GoRoute(
      path: "/role-check",
      builder: (context, state) => const _RoleCheckScreen(),
    ),
    GoRoute(
      name: AppRoutes.getStarted,
      path: '/${AppRoutes.getStarted}',
      builder: (context, state) => const GetStartedScreen(),
    ), GoRoute(
      name: AppRoutes.onBoarding,
      path: '/${AppRoutes.onBoarding}',
      builder: (context, state) => const OnboardingScreen(),
    ),

    
    GoRoute(
      name: AppRoutes.login,
      path: '/${AppRoutes.login}',
      builder: (c, s) => const LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.register,
      path: '/${AppRoutes.register}',
      builder: (c, s) => const RegisterScreen(),
    ),
    GoRoute(
      name: AppRoutes.forgotPassword,
      path: '/${AppRoutes.forgotPassword}:email',
      builder: (c, s) =>
          ForgetPasswordScreen(email: s.pathParameters['email']!),
    ),

    ShellRoute(
      builder: (context, state, child) => DashBoardLayout(child: child),

      routes: [
        GoRoute(
          name: 'analytics',
          path: AppRoutes.analytics,
          builder: (c, s) => const AnalyticsScreen(),
        ),

        // Products
        GoRoute(
          name: 'products',
          path: AppRoutes.products,
          builder: (c, s) => const ProductsScreen(),
          routes: [
            // المسارات الثابتة لازم تكون قبل :id
            GoRoute(
              name: 'addProduct',
              path: AppRoutes.addProduct,
              builder: (c, s) => const AddProductScreen(isUpdate: false),
            ),
            GoRoute(
              name: 'updateProduct',
              path: ':id/edit',
              builder: (c, s) => AddProductScreen(
                isUpdate: true,
                productId: s.pathParameters['id']!,
              ),
            ),
           GoRoute(
  name: 'productDetails',
  path: ':pId',
  builder: (context, state) {
    final pId = state.pathParameters['pId']!;

    return ProductDetailsScreen(
      pId: pId,
      tagId: 'product-$pId',
      product: _productFromExtra(state.extra),
    );
  },
),
          ],
        ),

        // Orders
        GoRoute(
          name: 'orders',
          path: AppRoutes.orders,
          builder: (c, s) => const OrdersScreen(),
          routes: [
            GoRoute(
              name: 'orderDetails',
              path: '${AppRoutes.orderDetails}/:orderId',
              builder: (c, s) => OrdersDetailsScreen(
                orderId: s.pathParameters['orderId']!,
                order: _orderFromExtra(s.extra),
              ),
            ),
          ],
        ),

        // Users
        GoRoute(
          name: 'users',
          path: AppRoutes.users,
          builder: (c, s) => const UsersScreen(),
          routes: [
            GoRoute(
              name: 'staffProductScreen',
              path: AppRoutes.staffProductScreen,
              builder: (c, s) {
                final staffId = s.extra;
                return staffId is String && staffId.isNotEmpty
                    ? StaffProductScreen(staffId: staffId)
                    : const _MissingUserRouteDataScreen();
              },
            ),
            GoRoute(
              name: 'customerOrders',
              path: '${AppRoutes.customerOrders}/:userName',
              builder: (c, s) {
                final customer = s.extra;
                return customer is UserEntity
                    ? CustomerOrderScreen(customer: customer)
                    : const _MissingUserRouteDataScreen();
              },
            ),
            GoRoute(
              name: 'addNotification',
              path: 'add-notification/:userName',
              builder: (c, s) => AddNotificationScreen(
                fCM: _notificationTokenFromExtra(s.extra),
                userName: s.pathParameters['userName']!,
              ),
            ),
          ],
        ),

        // Search
        GoRoute(
          name: 'search',
          path: AppRoutes.search,
          builder: (c, s) => const SearchScreen(),
          routes: [
            GoRoute(
              name: 'dashboardSearchResult',
              path: AppRoutes.dashboardSearchResult,
              builder: (c, s) =>
                  ProductsSearchResult(query: s.uri.queryParameters['q']!),
            ),
          ],
        ),

        // Most sold products
        GoRoute(
          name: 'productsMostSold',
          path: AppRoutes.productsMostSold,
          builder: (c, s) => ProductListScreen(
            products: s.extra as List<ProductMostSellerModel>,
          ),
        ),
      ],
    ),
  ],
);

class _RoleCheckScreen extends StatefulWidget {
  const _RoleCheckScreen();

  @override
  State<_RoleCheckScreen> createState() => _RoleCheckScreenState();
}

class _RoleCheckScreenState extends State<_RoleCheckScreen> {
  Future<UserEntity>? _userFuture;
  bool _isRedirecting = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      _scheduleRedirect(AppRoutes.getStarted);
    } else {
      _loadUser();
    }
  }

  void _loadUser() {
    _userFuture = getIt<FirestoreService>().getUserData();
  }

  void _scheduleRedirect(String routeName) {
    if (_isRedirecting) return;
    _isRedirecting = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.goNamed(routeName);
      }
    });
  }

  void _retry() {
    setState(() {
      _isRedirecting = false;
      _loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userFuture = _userFuture;
    if (userFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return FutureBuilder<UserEntity>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _RoleCheckError(
            onRetry: _retry,
            onSignIn: () => context.goNamed(AppRoutes.login),
          );
        }

        if (snapshot.data!.isStaff) {
          _scheduleRedirect(AppRoutes.products);
        } else {
          _scheduleRedirect(AppRoutes.login);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Warning.showWarning(
                context,
                message: 'This application is for staff only',
              );
            }
          });
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _RoleCheckError extends StatelessWidget {
  const _RoleCheckError({required this.onRetry, required this.onSignIn});

  final VoidCallback onRetry;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Could not load your account information. Check your connection and try again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
              TextButton(onPressed: onSignIn, child: const Text('Sign in')),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingUserRouteDataScreen extends StatelessWidget {
  const _MissingUserRouteDataScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'User information is unavailable. Open this screen from Users.',
            ),
            TextButton(
              onPressed: () => context.go(AppRoutes.users),
              child: const Text('Go to Users'),
            ),
          ],
        ),
      ),
    );
  }
}
