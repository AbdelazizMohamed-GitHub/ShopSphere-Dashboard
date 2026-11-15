import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_sphere_dashboard/features/products/data/model/product_model.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';
import 'package:shop_sphere_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:shop_sphere_dashboard/features/products/presention/controller/product_cubit/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required this.productsRepo}) : super(ProductsInitial());

  final ProductsRepo productsRepo;
  final List<ProductModel> products = [];
  ProductEntity? currentProduct;

  Future<void> getProducts() async {
    emit(ProductsLoading());
    var result = await productsRepo.getProducts(category: 'All');
    result.fold(
      (error) {
        emit(ProductsFailer(errMessage: error.message));
      },
      (products) {
        emit(GetProductsSuccess(products: products));
      },
    );
  }

  Future<void> getProductById({
    required String productId,
    ProductEntity? initialProduct,
  }) async {
    if (productId.isEmpty) {
      emit(const ProductDetailsFailure(errMessage: 'Product ID is required.'));
      return;
    }

    if (initialProduct != null) {
      currentProduct = initialProduct;
      emit(ProductDetailsSuccess(product: initialProduct));
      return;
    }

    emit(ProductDetailsLoading());
    final result = await productsRepo.getProductById(productId: productId);
    result.fold(
      (error) {
        emit(ProductDetailsFailure(errMessage: error.message));
      },
      (product) {
        currentProduct = product;
        emit(ProductDetailsSuccess(product: product));
      },
    );
  }

  Future<void> searchProducts({required String query}) async {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      emit(const ProductsFailer(errMessage: 'Search query is required.'));
      return;
    }

    emit(ProductsLoading());
    final result = await productsRepo.getProducts(category: 'All');
    result.fold(
      (error) {
        emit(ProductsFailer(errMessage: error.message));
      },
      (products) {
        final matches = products.where((product) {
          return product.name.toLowerCase().contains(normalizedQuery) ||
              product.description.toLowerCase().contains(normalizedQuery) ||
              product.category.toLowerCase().contains(normalizedQuery);
        }).toList();
        emit(ProductsSearchSuccess(products: matches));
      },
    );
  }

  Future<void> addProduct({
    required ProductModel product,
    required Uint8List imageFile,
  }) async {
    emit(ProductsLoading());
    var result = await productsRepo.addProduct(
      product: product,
      imageFile: imageFile,
    );
    result.fold(
      (error) {
        emit(ProductsFailer(errMessage: error.message));
      },
      (r) async {
        emit(const ProductsSuccess());
      },
    );
  }

  Future<void> deleteProduct({required String dId, required imageUrl}) async {
    emit(ProductsLoading());
    var result = await productsRepo.deleteProduct(dId: dId, imageUrl: imageUrl);
    result.fold(
      (error) {
        emit(ProductsFailer(errMessage: error.message));
      },
      (r) {
        emit(const ProductsSuccess());
      },
    );
  }

  Future<void> updateProduct({
    required String dId,
    required ProductModel data,
  }) async {
    emit(ProductsLoading());
    var result = await productsRepo.updateProduct(data: data);
    result.fold(
      (error) {
        emit(ProductsFailer(errMessage: error.message));
      },
      (r) {
        emit(const ProductsSuccess());
      },
    );
  }
}
