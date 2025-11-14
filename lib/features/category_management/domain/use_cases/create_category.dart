import 'package:team1/features/category_management/domain/entities/category.dart';
import 'package:team1/features/category_management/domain/repositories/category_repository.dart';

class CreateCategory {
  final CategoryRepository repository;

  CreateCategory(this.repository);

  Future<Category> call(Category category) {
    return repository.createCategory(category);
  }
}
