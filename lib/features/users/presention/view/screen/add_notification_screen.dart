import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_button.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_text_form.dart';
import 'package:shop_sphere_dashboard/core/widget/warning.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/users/data/repo_impl/notification_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/users/presention/controller/add_notification_cubit/add_notification_cubit.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/widget/custom_getproduct_widget.dart';
import 'package:shop_sphere_dashboard/features/users/presention/view/widget/custom_selected_product_card.dart';

class AddNotificationScreen extends StatefulWidget {
  const AddNotificationScreen({
    super.key,
    required this.fCM,
    required this.userName,
  });

  final String fCM;
  final String userName;

  @override
  State<AddNotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<AddNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();


  ProductEntity? selectedProduct;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.getHorizontalLargePadding(
      context,
    );

    return BlocProvider(
      create: (_) =>
          AddNotificationCubit(notificationRepo: getIt<NotificationRepoImpl>()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Product Offer'),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send offer to ${widget.userName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  CustomTextForm(
                    text: 'Notification Title *',
                    textController: _titleController,
                    kType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    text: 'Notification Body *',
                    textController: _bodyController,
                    lines: 4,
                    kType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select Product *',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  CustomGetproductWidget(
                    selectedProduct: (product) {
                      setState(() {
                        selectedProduct = product;
                      });
                    },
                  ),
                  if (selectedProduct != null) ...[
                    const SizedBox(height: 20),
                    Customselectedproductcard(product: selectedProduct!),
                  ],
                  const SizedBox(height: 32),
                  BlocConsumer<AddNotificationCubit, AddNotificationState>(
                    listener: (context, state) {
                      if (state is AddNotificationSuccess) {
                        Warning.showWarning(
                          context,
                          message: 'Notification sent successfully',
                          isError: false,
                        );
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.users);
                        }
                      } else if (state is AddNotificationFailure) {
                        Warning.showWarning(
                          context,
                          message: state.errMessage,
                          isError: true,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AddNotificationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CustomButton(
                        text: state is AddNotificationFailure
                            ? 'Retry'
                            : 'Send To ${widget.userName}',
                        onPressed:
                            widget.fCM.trim().isEmpty ||
                                widget.userName.trim().isEmpty
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) return;
                                final product = selectedProduct;
                                if (product == null) {
                                  Warning.showWarning(
                                    context,
                                    message: 'Please select a product',
                                    isError: true,
                                  );
                                  return;
                                }
                                context
                                    .read<AddNotificationCubit>()
                                    .addNotification(
                                      title: _titleController.text.trim(),
                                      body: _bodyController.text.trim(),
                                      productId: product.pId,
                                      imageUrl: product.imageUrl,
                                      token: widget.fCM.trim(),
                                    );
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  }

  
