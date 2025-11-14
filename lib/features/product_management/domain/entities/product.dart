import 'package:equatable/equatable.dart';
import 'dart:io';

class Product extends Equatable {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final int categoryId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? averageRating;
  final String? mainImageUrl;
  final File? mainImageFile;
  final List<File>? galleryImageFiles;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    required this.stockQuantity,
    required this.categoryId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.averageRating,
    this.mainImageUrl,
    this.mainImageFile,
    this.galleryImageFiles,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    discountPrice,
    stockQuantity,
    categoryId,
    isActive,
    createdAt,
    updatedAt,
    averageRating,
    mainImageUrl,
    mainImageFile,
    galleryImageFiles,
  ];
}
