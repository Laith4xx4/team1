import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/domain/use_cases/get_all_products.dart';
import 'package:team1/features/product_management/domain/use_cases/create_product.dart';
import 'package:team1/features/product_management/domain/use_cases/update_product.dart';
import 'package:team1/features/product_management/domain/use_cases/delete_product.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts _getAllProducts;
  final CreateProduct _createProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  List<Product> allProducts = []; // لتحميل كل المنتجات مرة واحدة

  ProductCubit(
      this._getAllProducts,
      this._createProduct,
      this._updateProduct,
      this._deleteProduct,
      ) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      allProducts = await _getAllProducts();
      emit(ProductLoaded(products: allProducts));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void loadProductsByCategory(int? categoryId) {
    if (categoryId == null) {
      emit(ProductLoaded(products: allProducts));
    } else {
      final filtered = allProducts.where((p) => p.categoryId == categoryId).toList();
      emit(ProductLoaded(products: filtered));
    }
  }

  Future<void> addProduct(Product product) async {
    emit(ProductLoading());
    try {
      await _createProduct(product);
      allProducts.add(product); // أضف المنتج للقائمة المحلية
      emit(const ProductActionSuccess(message: 'Product created successfully!'));
      emit(ProductLoaded(products: allProducts));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> updateProduct(Product product) async {
    emit(ProductLoading());
    try {
      await _updateProduct(product);
      // تحديث المنتج في القائمة المحلية
      final index = allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        allProducts[index] = product;
      }
      emit(const ProductActionSuccess(message: 'Product updated successfully!'));
      emit(ProductLoaded(products: allProducts));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }


  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    try {
      await _deleteProduct(id);
      emit(const ProductActionSuccess(message: 'Product deleted successfully!'));
      allProducts.removeWhere((p) => p.id == id);
      emit(ProductLoaded(products: allProducts));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
