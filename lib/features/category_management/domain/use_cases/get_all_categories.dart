import 'package:team1/features/category_management/domain/entities/category.dart';
import 'package:team1/features/category_management/domain/repositories/category_repository.dart';

class GetAllCategories {
  final CategoryRepository repository;

  GetAllCategories(this.repository);

  Future<List<Category>> call() {
    return repository.getAllCategories();
  }
}
