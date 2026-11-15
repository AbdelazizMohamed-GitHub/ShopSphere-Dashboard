import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/theme/app_color.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';

class CustomLoginScreenHeader extends StatelessWidget {
  const CustomLoginScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Don\'t have an account?', style: AppStyles.text18Regular),
        TextButton(
          onPressed: () {
            context.pushNamed(AppRoutes.register);
          },
          child: Text(
            'Register',
            style: AppStyles.text18Regular.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
