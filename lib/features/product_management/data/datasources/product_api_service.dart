import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:team1/features/product_management/data/models/product_model.dart';
import 'package:path/path.dart' as path;

class ProductApiService {
  final String _baseUrl = 'http://192.168.100.66:5086/api/Products';

  // GET: جلب كل المنتجات
  Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData is List) {
        return decodedData.map((json) => ProductModel.fromJson(json)).toList();
      } else if (decodedData is Map && decodedData.containsKey('\$values')) {
        final productList = decodedData['\$values'] as List<dynamic>;
        return productList.map((json) => ProductModel.fromJson(json)).toList();
      } else if (decodedData is Map && decodedData.isEmpty) {
        return [];
      } else {
        throw Exception('Unexpected response format for products: $decodedData');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // POST: إنشاء منتج
  Future<ProductModel> createProduct(ProductModel product) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    request.fields['Name'] = product.name;
    request.fields['Description'] = product.description ?? '';
    request.fields['Price'] = product.price.toString();
    request.fields['DiscountPrice'] = (product.discountPrice ?? 0).toString();
    request.fields['StockQuantity'] = product.stockQuantity.toString();
    request.fields['CategoryId'] = product.categoryId.toString();
    request.fields['IsActive'] = product.isActive.toString();

    if (product.mainImageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'MainImageFile',
        product.mainImageFile!.path,
        filename: path.basename(product.mainImageFile!.path),
      ));
    }

    if (product.galleryImageFiles != null) {
      for (var file in product.galleryImageFiles!) {
        request.files.add(await http.MultipartFile.fromPath(
          'GalleryImageFiles',
          file.path,
          filename: path.basename(file.path),
        ));
      }
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to create product: ${response.statusCode} - $responseBody');
    }
  }

  // PUT: تحديث منتج
  Future<ProductModel> updateProduct(ProductModel product) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/${product.id}'));

    request.fields['ProductId'] = product.id.toString();
    request.fields['Name'] = product.name;
    request.fields['Description'] = product.description ?? '';
    request.fields['Price'] = product.price.toString();
    request.fields['DiscountPrice'] = (product.discountPrice ?? 0).toString();
    request.fields['StockQuantity'] = product.stockQuantity.toString();
    request.fields['CategoryId'] = product.categoryId.toString();
    request.fields['IsActive'] = product.isActive.toString();

    if (product.mainImageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'MainImageFile',
        product.mainImageFile!.path,
        filename: path.basename(product.mainImageFile!.path),
      ));
    }

    if (product.galleryImageFiles != null) {
      for (var file in product.galleryImageFiles!) {
        request.files.add(await http.MultipartFile.fromPath(
          'GalleryImageFiles',
          file.path,
          filename: path.basename(file.path),
        ));
      }
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(responseBody));
    } else if (response.statusCode == 204) {
      // No Content → نعيد نسخة من المنتج المحدث محلياً
      return product;
    } else {
      throw Exception('Failed to update product: ${response.statusCode} - $responseBody');
    }
  }

  // DELETE: حذف منتج
  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}
