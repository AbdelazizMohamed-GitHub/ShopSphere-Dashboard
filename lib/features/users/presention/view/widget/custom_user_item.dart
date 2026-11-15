import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/utils/app_images.dart';
import 'package:shop_sphere_dashboard/core/theme/app_styles.dart';
import 'package:shop_sphere_dashboard/features/auth/domain/entity/user_entity.dart';
import 'package:shop_sphere_dashboard/features/users/presention/controller/user_cubit/users_cubit.dart';

class CustomUserItem extends StatelessWidget {
  const CustomUserItem({
    super.key,
    required this.currentIndex,
    required this.index,
    required this.users,
  });
  final int currentIndex;
  final int index;
  final List<UserEntity> users;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          users[index].uid.isEmpty ||
              (currentIndex == 1 && users[index].name.isEmpty)
          ? null
          : () {
              currentIndex == 0
                  ? context.pushNamed(
                      'staffProductScreen',
                      extra: users[index].uid,
                    )
                  : context.pushNamed(
                      'customerOrders',
                      pathParameters: {'userName': users[index].name},
                      extra: users[index],
                    );
            },
      child: SizedBox(
        height: 100,
        child: Card(
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              users[index].name,
              maxLines: 1,
              style: AppStyles.text16Bold,
            ),
            subtitle: Text(users[index].email, maxLines: 1),
            trailing: SizedBox(
              width: 100,
              height: 50,
              child: Row(
                children: [
                  currentIndex == 1
                      ? IconButton(
                          onPressed:
                              users[index].fcmToken.trim().isEmpty ||
                                  users[index].name.isEmpty
                              ? null
                              : () {
                                  context.pushNamed(
                                    'addNotification',
                                    pathParameters: {
                                      'userName': users[index].name,
                                    },
                                    extra: users[index].fcmToken,
                                  );
                                },
                          icon: const Icon(Icons.notification_add_outlined),
                        )
                      : const SizedBox(),
                  Switch(
                    value: currentIndex == 0,
                    onChanged: (value) async {
                      await context.read<MangeUsersCubit>().changeUserRule(
                        userId: users[index].uid,
                        isStaff: value,
                      );
                    },
                  ),
                ],
              ),
            ),
            leading: Image.asset(AppImages.profile),
          ),
        ),
      ),
    );
  }
}
