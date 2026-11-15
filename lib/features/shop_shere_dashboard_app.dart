import 'package:flutter/material.dart';
import 'package:shop_sphere_dashboard/core/app/app_router.dart';
import 'package:shop_sphere_dashboard/core/theme/app_color.dart';

class ShopSphereDashboardApp extends StatelessWidget {
  const ShopSphereDashboardApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShopSphereDashboard',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
    );
  }
}
