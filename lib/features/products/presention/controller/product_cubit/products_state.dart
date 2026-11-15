import 'package:equatable/equatable.dart';
import 'package:shop_sphere_dashboard/features/products/domain/entity/proudct_entity.dart';

class ProductsState extends Equatable {
  final int screenIndex;
  const ProductsState({this.screenIndex = 0});
  @override
  List<Object?> get props => [screenIndex];
}

class ProductsChangeScreenIndex extends ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  const ProductsSuccess();
}

class GetProductsSuccess extends ProductsState {
  final List<ProductEntity> products;
  const GetProductsSuccess({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductsSearchSuccess extends ProductsState {
  final List<ProductEntity> products;
  const ProductsSearchSuccess({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductDetailsLoading extends ProductsState {}

class ProductDetailsSuccess extends ProductsState {
  final ProductEntity product;
  const ProductDetailsSuccess({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductDetailsFailure extends ProductsState {
  final String errMessage;
  const ProductDetailsFailure({required this.errMessage});

  @override
  List<Object?> get props => [errMessage];
}

class ProductsFailer extends ProductsState {
  final String errMessage;
  const ProductsFailer({required this.errMessage});

  @override
  List<Object?> get props => [errMessage];
}
