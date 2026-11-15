import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_data.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/firestore_service.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_button.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_dropdown_menu.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_text_form.dart';
import 'package:shop_sphere_dashboard/core/widget/warning.dart';
import 'package:shop_sphere_dashboard/features/products/data/model/product_model.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_cubit.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_state.dart';
import 'package:shop_sphere_dashboard/features/products/data/repo_impl/products_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/products/presention/view/widget/custom_add_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    super.key,
    required this.isUpdate,
    this.productEntity,
    this.productId,
  });
  final ProductEntity? productEntity;
  final String? productId;
  final bool isUpdate;
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int discount = 0;
  Uint8List? imageFile;
  String? _loadedProductId;

  @override
  void initState() {
    super.initState();
  }

  void _applyProduct(ProductEntity product) {
    if (_loadedProductId == product.pId) return;
    _loadedProductId = product.pId;
    nameController.text = product.name;
    quantityController.text = product.stock.toString();
    priceController.text = product.price.toString();
    descriptionController.text = product.description;
    selectedCategory = product.category;
    discount = product.discount;
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  String dId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ProductsCubit(productsRepo: getIt<ProductsRepoImpl>());
        if (widget.isUpdate) {
          final productId = widget.productId ?? widget.productEntity?.pId;
          if (productId != null && productId.isNotEmpty) {
            cubit.getProductById(
              productId: productId,
              initialProduct: widget.productEntity,
            );
          }
        }
        return cubit;
      },
      child: Builder(
        builder: (context) {
          return BlocListener<ProductsCubit, ProductsState>(
            listenWhen: (_, state) => state is ProductDetailsSuccess,
            listener: (context, state) {
              if (state is ProductDetailsSuccess) {
                setState(() => _applyProduct(state.product));
              }
            },
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                final product =
                    widget.productEntity ??
                    context.read<ProductsCubit>().currentProduct;
                if (widget.isUpdate && product == null) {
                  if (state is ProductDetailsFailure) {
                    return Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        title: const Text('Update Product'),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.errMessage),
                            TextButton(
                              onPressed: widget.productId == null
                                  ? null
                                  : () => context
                                        .read<ProductsCubit>()
                                        .getProductById(
                                          productId: widget.productId!,
                                        ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ProductsInitial) {
                    return const Scaffold(
                      body: Center(child: Text('A product ID is required.')),
                    );
                  }
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: const Text('Update Product'),
                    ),
                    body: const Skeletonizer(
                      enabled: true,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Product name'),
                            SizedBox(height: 20),
                            Text('Product description'),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (product != null &&
                    widget.isUpdate &&
                    _loadedProductId != product.pId) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _loadedProductId != product.pId) {
                      setState(() => _applyProduct(product));
                    }
                  });
                }
                return _buildForm(context, product);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProductEntity? product) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    double horizontalPadding = ResponsiveLayout.getHorizontalLargePadding(
      context,
    );
    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.isUpdate ? "Update Product" : "Add Product"),
            ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Column(
              children: [
                CustomTextForm(
                  textController: nameController,
                  pIcon: Icons.title,
                  text: "Product Name",
                  kType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                CustomTextForm(
                  textController: quantityController,
                  pIcon: Icons.numbers,
                  text: "Product Quantity",
                  kType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextForm(
                        textController: priceController,
                        pIcon: Icons.money_off_rounded,
                        text: " Price",
                        kType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: CustomDropdown(
                        isUpdate: widget.isUpdate,
                        categories: const [
                          '0',
                          '5',
                          '10',
                          '20',
                          '30',
                          '40',
                          '50',
                          '60',
                          '70',
                          '80',
                          '90',
                          '100',
                        ],
                        onCategorySelected: (value) {
                          discount = int.parse(value);
                        },
                        text: "Discount",
                        productCategory: discount.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomDropdown(
                  text: "Product Category",
                  productCategory: selectedCategory,
                  isUpdate: widget.isUpdate,
                  categories: AppData.appCategoryList
                      .map((e) => e.toString())
                      .toList(),
                  onCategorySelected: (value) {
                    selectedCategory = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextForm(
                  textController: descriptionController,
                  pIcon: null,
                  text: "Product Description",
                  kType: TextInputType.text,
                  lines: 4,
                ),
                const SizedBox(height: 15),
                CustomAddImage(
                  imageUrl: widget.isUpdate ? product!.imageUrl : "",
                  onTap: (Uint8List file) {
                    imageFile = file;
                  },
                ),
                const SizedBox(height: 20),
                BlocConsumer<ProductsCubit, ProductsState>(
                  listener: (context, state) {
                    if (state is ProductsFailer) {
                      print("Error: ${state.errMessage}");
                      Warning.showWarning(
                        context,
                        message: state.errMessage,
                        isError: true,
                      );
                    }
                    if (state is ProductsSuccess) {
                      Warning.showWarning(
                        context,
                        message: widget.isUpdate
                            ? "Product Updated Successfully"
                            : "Product Added Successfully",
                      );
                      context.go(AppRoutes.products);
                    }
                  },
                  builder: (context, state) {
                    return state is ProductsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate() &&
                                  selectedCategory != null) {
                                if (imageFile != null || widget.isUpdate) {
                                  final user = await FirestoreService(
                                    firestore: FirebaseFirestore.instance,
                                  ).getUserData();

                                  final baseProduct = widget.isUpdate
                                      ? ProductModel(
                                          discount: discount,
                                          staffName: product!.staffName,
                                          createdAt:
                                              product.createdAt ??
                                              DateTime.now(),
                                          name: nameController.text,
                                          price: double.parse(
                                            priceController.text,
                                          ),
                                          stock: int.parse(
                                            quantityController.text,
                                          ),
                                          category: selectedCategory!,
                                          description:
                                              descriptionController.text,
                                          pId: product.pId,
                                          sId: product.sId,
                                          imageUrl: product.imageUrl,
                                          isFeatured: product.isFeatured,
                                        )
                                      : ProductModel(
                                          discount: discount,
                                          staffName: user.name,
                                          createdAt: DateTime.now(),
                                          name: nameController.text,
                                          price: double.parse(
                                            priceController.text,
                                          ),
                                          stock: int.parse(
                                            quantityController.text,
                                          ),
                                          category: selectedCategory!,
                                          description:
                                              descriptionController.text,
                                          pId: dId,
                                          sId: FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                          imageUrl: '',
                                          isFeatured: false,
                                        );

                                  if (widget.isUpdate) {
                                    await context
                                        .read<ProductsCubit>()
                                        .updateProduct(
                                          dId: product!.pId,
                                          data: baseProduct,
                                        );
                                  } else {
                                    await context
                                        .read<ProductsCubit>()
                                        .addProduct(
                                          product: baseProduct,
                                          imageFile: imageFile!,
                                        );
                                  }
                                } else {
                                  Warning.showWarning(
                                    context,
                                    message: "Please Add Image",
                                  );
                                }
                              }
                            },
                            text: state is ProductsFailer
                                ? "Retry"
                                : widget.isUpdate
                                ? "Update Product"
                                : "Add Product",
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
