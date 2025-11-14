import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/domain/repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<List<Product>> call() {
    return repository.getAllProducts();
  }
}
