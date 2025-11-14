import 'package:equatable/equatable.dart';
import 'package:team1/features/product_management/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductActionSuccess extends ProductState {
  final String message;

  const ProductActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
