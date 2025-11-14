import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/domain/repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Product> call(Product product) {
    return repository.updateProduct(product);
  }
}
