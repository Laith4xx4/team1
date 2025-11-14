import 'package:team1/features/product_management/domain/entities/product.dart';
import 'dart:io';

class ProductModel extends Product {
  const ProductModel({
    required int id,
    required String name,
    String? description,
    required double price,
    double? discountPrice,
    required int stockQuantity,
    required int categoryId,
    required bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
    double? averageRating,
    String? mainImageUrl,
    File? mainImageFile,
    List<File>? galleryImageFiles,
  }) : super(
         id: id,
         name: name,
         description: description,
         price: price,
         discountPrice: discountPrice,
         stockQuantity: stockQuantity,
         categoryId: categoryId,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
         averageRating: averageRating,
         mainImageUrl: mainImageUrl,
         mainImageFile: mainImageFile,
         galleryImageFiles: galleryImageFiles,
       );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['productId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      categoryId: json['categoryId'] as int,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      mainImageUrl:
          (json['productImages'] as List<dynamic>?)?.isNotEmpty == true
          ? (json['productImages'] as List<dynamic>).first['imageUrl']
                as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'stockQuantity': stockQuantity,
      'categoryId': categoryId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'averageRating': averageRating,
    };
  }

  Map<String, dynamic> toCreateModel() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'stockQuantity': stockQuantity,
      'categoryId': categoryId,
    };
  }

  Map<String, dynamic> toUpdateModel() {
    return {
      'productId': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'stockQuantity': stockQuantity,
      'categoryId': categoryId,
      'isActive': isActive,
    };
  }
}
