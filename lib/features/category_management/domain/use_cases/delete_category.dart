import 'package:team1/features/category_management/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(int id) {
    return repository.deleteCategory(id);
  }
}
