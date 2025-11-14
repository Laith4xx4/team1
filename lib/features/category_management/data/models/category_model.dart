import 'package:team1/features/category_management/domain/entities/category.dart';
import 'dart:io';

class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required String name,
    String? description,
    String? imageUrl,
    int? parentCategoryId,
    required bool isActive,
    required DateTime createdAt,
    File? image,
  }) : super(
         id: id,
         name: name,
         description: description,
         imageUrl: imageUrl,
         parentCategoryId: parentCategoryId,
         isActive: isActive,
         createdAt: createdAt,
         image: image,
       );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['categoryId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      parentCategoryId: json['parentCategoryId'] as int?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'parentCategoryId': parentCategoryId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Method for creating a new category, excluding the ID
  Map<String, dynamic> toCreateModel() {
    return {
      'name': name,
      'description': description,
      'parentCategoryId': parentCategoryId,
    };
  }
}
