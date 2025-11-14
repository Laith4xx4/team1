import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/domain/repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Product> call(Product product) {
    return repository.createProduct(product);
  }
}
