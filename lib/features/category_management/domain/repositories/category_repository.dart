import 'package:team1/features/category_management/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(int id);
}
