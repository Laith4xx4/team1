import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/domain/use_cases/create_product.dart';
import 'package:team1/features/product_management/domain/use_cases/delete_product.dart';
import 'package:team1/features/product_management/domain/use_cases/get_all_products.dart';
import 'package:team1/features/product_management/domain/use_cases/update_product.dart';
import 'package:team1/features/product_management/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts _getAllProducts;
  final CreateProduct _createProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  ProductCubit(
    this._getAllProducts,
    this._createProduct,
    this._updateProduct,
    this._deleteProduct,
  ) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await _getAllProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> addProduct(Product product) async {
    emit(ProductLoading());
    try {
      await _createProduct(product);
      emit(const ProductActionSuccess(message: 'Product created successfully!'));
      await loadProducts(); // Reload products after successful creation
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> updateProduct(Product product) async {
    emit(ProductLoading());
    try {
      await _updateProduct(product);
      emit(const ProductActionSuccess(message: 'Product updated successfully!'));
      await loadProducts(); // Reload products after successful update
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    try {
      await _deleteProduct(id);
      emit(const ProductActionSuccess(message: 'Product deleted successfully!'));
      await loadProducts(); // Reload products after successful deletion
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
