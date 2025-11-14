import 'package:team1/features/category_management/domain/entities/category.dart';
import 'package:team1/features/category_management/domain/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<Category> call(Category category) {
    return repository.updateCategory(category);
  }
}
