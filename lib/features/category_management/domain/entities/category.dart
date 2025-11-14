import 'package:equatable/equatable.dart';
import 'dart:io';

class Category extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int? parentCategoryId;
  final bool isActive;
  final DateTime createdAt;
  final File? image;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.parentCategoryId,
    required this.isActive,
    required this.createdAt,
    this.image,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    parentCategoryId,
    isActive,
    createdAt,
    image,
  ];
}
