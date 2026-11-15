import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/theme/app_color.dart';
import 'package:shop_sphere_dashboard/core/utils/app_images.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});
  @override
  Widget build(BuildContext context) {
        double herzontilPadding = ResponsiveLayout.getHorizontalLargePadding (context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: herzontilPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               
                const SizedBox(height: 32),
                Image.asset(
                  AppImages.onboarding1,
                  height: 240,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome to Shop Sphere',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Manage your store and keep everything running smoothly.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => context.pushNamed(AppRoutes.onBoarding),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
