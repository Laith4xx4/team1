import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/presentation/cubit/product_cubit.dart';
import 'package:team1/features/product_management/presentation/cubit/product_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:team1/features/category_management/domain/entities/category.dart';
import 'package:team1/features/category_management/presentation/cubit/category_cubit.dart';
import 'package:team1/features/category_management/presentation/cubit/category_state.dart';

const String _baseImageUrl =
    'http://192.168.100.66:5086/'; // Define your base image URL here

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  File? _mainImageFile;
  List<File> _galleryImageFiles = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
    context
        .read<CategoryCubit>()
        .loadCategories(); // Load categories for dropdown
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _stockQuantityController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _discountPriceController.clear();
    _stockQuantityController.clear();
    _categoryIdController.clear();
    setState(() {
      _mainImageFile = null;
      _galleryImageFiles = [];
      _selectedCategory = null;
    });
  }

  Future<void> _pickMainImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _mainImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickGalleryImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _galleryImageFiles.addAll(pickedFiles.map((x) => File(x.path)));
      });
    }
  }

  void _showAddEditProductDialog({Product? product}) {
    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toString();
      _discountPriceController.text = product.discountPrice?.toString() ?? '';
      _stockQuantityController.text = product.stockQuantity.toString();
      _categoryIdController.text = product.categoryId.toString();
      _mainImageFile = product.mainImageFile;
      _galleryImageFiles = product.galleryImageFiles ?? [];
      // Set selected category if available in the loaded categories
      final categoriesState = context.read<CategoryCubit>().state;
      if (categoriesState is CategoryLoaded) {
        _selectedCategory = categoriesState.categories.firstWhere(
          (cat) => cat.id == product.categoryId,
          orElse: () =>
              categoriesState.categories.first, // Fallback to first category
        );
      }
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      builder: (context) => BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          List<Category> categories = [];
          if (categoryState is CategoryLoaded) {
            categories = categoryState.categories;
          }
          return AlertDialog(
            title: Text(product == null ? 'Add Product' : 'Edit Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number, // Ensure numeric input
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  TextField(
                    controller: _discountPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discount Price',
                    ),
                  ),
                  TextField(
                    controller: _stockQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock Quantity',
                    ),
                  ),
                  // Category Dropdown
                  DropdownButtonFormField<Category>(
                    value:
                        _selectedCategory, // This should be a Category object, not int
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                        _categoryIdController.text =
                            newValue?.id.toString() ?? '';
                      });
                    },
                  ),

                  // Main Image Picker
                  // ElevatedButton(
                  //   onPressed: _pickMainImage,
                  //   child: const Text('Pick Main Image'),
                  // ),
                  if (_mainImageFile != null)
                    Image.file(_mainImageFile!, height: 100, width: 100),

                  // Gallery Image Picker
                  ElevatedButton(
                    onPressed: _pickGalleryImages,
                    child: const Text('Pick Gallery Images'),
                  ),
                  if (_galleryImageFiles.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _galleryImageFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _galleryImageFiles[index],
                              width: 80,
                              height: 80,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newProduct = Product(
                    id: product?.id ?? 0,
                    name: _nameController.text,
                    description: _descriptionController.text.isEmpty
                        ? null
                        : _descriptionController.text,
                    price: double.parse(_priceController.text),
                    discountPrice: _discountPriceController.text.isEmpty
                        ? null
                        : double.parse(_discountPriceController.text),
                    stockQuantity: int.parse(_stockQuantityController.text),
                    categoryId:
                        _selectedCategory?.id ?? 0, // Use selected category ID
                    isActive:
                        product?.isActive ??
                        true, // Keep existing isActive or default to true
                    createdAt: product?.createdAt ?? DateTime.now(),
                    updatedAt: product?.updatedAt,
                    averageRating: product?.averageRating,
                    mainImageFile: _mainImageFile,
                    galleryImageFiles: _galleryImageFiles.isEmpty
                        ? null
                        : _galleryImageFiles,
                  );
                  if (product == null) {
                    context.read<ProductCubit>().addProduct(newProduct);
                  } else {
                    context.read<ProductCubit>().updateProduct(newProduct);
                  }
                  Navigator.pop(context);
                },
                child: Text(product == null ? 'Add' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditProductDialog(),
          ),
        ],
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is ProductActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                print(
                  'Product Name: ${product.name}, Main Image URL: ${product.mainImageUrl}',
                );
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child:
                          product.mainImageUrl != null &&
                              product.mainImageUrl!.startsWith('file://')
                          ? Image.file(
                              File(
                                product.mainImageUrl!.replaceFirst(
                                  'file://',
                                  '',
                                ),
                              ),
                              fit: BoxFit.cover,
                            )
                          : (product.mainImageUrl != null
                                ? Image.network(
                                    _baseImageUrl + product.mainImageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported)),
                    ),
                    title: Text(product.name),
                    subtitle: Text(
                      'Price: \$${product.price.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showAddEditProductDialog(product: product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<ProductCubit>().deleteProduct(
                              product.id,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No products to display.'));
        },
      ),
    );
  }
}
