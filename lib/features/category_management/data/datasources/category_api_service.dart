import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:team1/features/category_management/data/models/category_model.dart';
import 'package:path/path.dart' as path;

class CategoryApiService {
  final String _baseUrl = 'http://192.168.100.66:5086/api/Categories';

  Future<List<CategoryModel>> getAllCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<CategoryModel> createCategory(CategoryModel category) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    request.fields['Name'] = category.name;
    if (category.description != null) {
      request.fields['Description'] = category.description!;
    }
    if (category.parentCategoryId != null) {
      request.fields['ParentCategoryId'] = category.parentCategoryId.toString();
    }

    if (category.image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'Image',
          category.image!.path,
          filename: path.basename(category.image!.path),
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return CategoryModel.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
        'Failed to create category: ${response.statusCode} - $responseBody',
      );
    }
  }

  Future<CategoryModel> updateCategory(CategoryModel category) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$_baseUrl/${category.id}'),
    );

    request.fields['Name'] = category.name;
    if (category.description != null) {
      request.fields['Description'] = category.description!;
    } else {
      request.fields['Description'] =
          ''; // Explicitly send empty string if null
    }
    if (category.parentCategoryId != null) {
      request.fields['ParentCategoryId'] = category.parentCategoryId.toString();
    } else {
      request.fields['ParentCategoryId'] =
          '0'; // Explicitly send 0 if null, if backend expects it
    }
    request.fields['IsActive'] = category.isActive.toString();

    if (category.image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'Image',
          category.image!.path,
          filename: path.basename(category.image!.path),
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return CategoryModel.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
        'Failed to update category: ${response.statusCode} - $responseBody',
      );
    }
  }

  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }
}
