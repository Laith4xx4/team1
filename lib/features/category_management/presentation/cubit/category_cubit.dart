import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/category_management/domain/entities/category.dart';
import 'package:team1/features/category_management/domain/use_cases/create_category.dart';
import 'package:team1/features/category_management/domain/use_cases/delete_category.dart';
import 'package:team1/features/category_management/domain/use_cases/get_all_categories.dart';
import 'package:team1/features/category_management/domain/use_cases/update_category.dart';
import 'package:team1/features/category_management/presentation/cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetAllCategories _getAllCategories;
  final CreateCategory _createCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  CategoryCubit(
    this._getAllCategories,
    this._createCategory,
    this._updateCategory,
    this._deleteCategory,
  ) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _getAllCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> addCategory(Category category) async {
    emit(CategoryLoading());
    try {
      await _createCategory(category);
      emit(const CategoryActionSuccess(message: 'Category created successfully!'));
      await loadCategories(); // Reload categories after successful creation
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> updateCategory(Category category) async {
    emit(CategoryLoading());
    try {
      await _updateCategory(category);
      emit(const CategoryActionSuccess(message: 'Category updated successfully!'));
      await loadCategories(); // Reload categories after successful update
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> deleteCategory(int id) async {
    emit(CategoryLoading());
    try {
      await _deleteCategory(id);
      emit(const CategoryActionSuccess(message: 'Category deleted successfully!'));
      await loadCategories(); // Reload categories after successful deletion
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
