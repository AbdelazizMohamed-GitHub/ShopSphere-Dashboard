import 'package:flutter/material.dart';
import 'package:shop_sphere_dashboard/core/theme/app_color.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/custom_fixed_drawer.dart';

class DashBoardLayout extends StatelessWidget {
  const DashBoardLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      drawer: isDesktop ? null : const CustomFixedDrawer(),
      body: Row(
        children: [
          if (isDesktop) const SizedBox(width: 250, child: CustomFixedDrawer()),
          Expanded(child: child),
        ],
      ),
    );
  }
}
