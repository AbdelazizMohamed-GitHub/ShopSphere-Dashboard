import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_data.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/core/theme/app_color.dart';
import 'package:shop_sphere_dashboard/core/utils/app_images.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/features/auth/data/repo_impl/auth_repo_impl.dart';

class CustomFixedDrawer extends StatelessWidget {
  const CustomFixedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Material(
      color: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            accountName: Text(
              FirebaseAuth.instance.currentUser?.displayName ?? 'Admin Name',
              style: AppStyles.text16Bold.copyWith(color: Colors.black),
            ),
            accountEmail: Text(
              FirebaseAuth.instance.currentUser?.email ?? 'Admin Email',
              style: AppStyles.text14Regular.copyWith(color: Colors.black),
            ),
            currentAccountPicture: const Image(
              image: AssetImage(AppImages.logo),
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: AppData.dashboardDrawerItems.length,
              itemBuilder: (context, index) {
                final item = AppData.dashboardDrawerItems[index];
                final isSelected =
                    currentLocation == item.route ||
                    currentLocation.startsWith('${item.route}/');

                return Material(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: AppStyles.text18Regular.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    leading: Icon(
                      item.icon,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      if (!isDesktop) Navigator.pop(context);
                      context.push(item.route);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 0.3, color: Colors.black),
          ListTile(
            title: const Text('SignOut'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await getIt<AuthRepoImpl>().signOut();
              context.goNamed(AppRoutes.getStarted);
            },
          ),
        ],
      ),
    );
  }
}
