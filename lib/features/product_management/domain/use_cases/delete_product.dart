import 'package:team1/features/product_management/domain/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<void> call(int id) {
    return repository.deleteProduct(id);
  }
}
