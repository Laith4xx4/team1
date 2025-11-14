import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/category_management/domain/entities/category.dart';
import 'package:team1/features/category_management/presentation/cubit/category_cubit.dart';
import 'package:team1/features/category_management/presentation/cubit/category_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

const String _baseImageUrl =
    'http://192.168.100.66:5086/'; // Define your base image URL here

class CategoryListingScreen extends StatefulWidget {
  const CategoryListingScreen({super.key});

  @override
  State<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends State<CategoryListingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _parentCategoryIdController =
      TextEditingController();
  bool _isActive = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _parentCategoryIdController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _parentCategoryIdController.clear();
    setState(() {
      _isActive = true;
      _selectedImage = null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showAddEditCategoryDialog({Category? category}) {
    if (category != null) {
      _nameController.text = category.name;
      _descriptionController.text = category.description ?? '';
      _imageUrlController.text = category.imageUrl ?? '';
      _parentCategoryIdController.text =
          category.parentCategoryId?.toString() ?? '';
      _isActive = category.isActive;
      _selectedImage = category.image; // Set existing image if available
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
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
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                readOnly: true, // Make it read-only as we'll use image picker
                onTap: _pickImage, // Allow picking image on tap
              ),
              if (_selectedImage != null) // Display selected image
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 100,
                  width: 100,
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _parentCategoryIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Parent Category ID (Optional)',
                ),
              ),
              Row(
                children: [
                  const Text('Is Active'),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ],
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
              final newCategory = Category(
                id: category?.id ?? 0,
                name: _nameController.text,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                imageUrl: category
                    ?.imageUrl, // Keep existing imageUrl for updates if no new image is picked
                parentCategoryId: int.tryParse(
                  _parentCategoryIdController.text,
                ),
                isActive: _isActive,
                createdAt: category?.createdAt ?? DateTime.now(),
                image: _selectedImage, // Pass the selected image
              );
              if (category == null) {
                context.read<CategoryCubit>().addCategory(newCategory);
              } else {
                context.read<CategoryCubit>().updateCategory(newCategory);
              }
              Navigator.pop(context);
            },
            child: Text(category == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(),
          ),
        ],
      ),
      body: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is CategoryActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: category.imageUrl != null
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              _baseImageUrl + category.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.category),
                    title: Text(category.name),
                    subtitle: Text(category.description ?? 'No description'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showAddEditCategoryDialog(category: category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<CategoryCubit>().deleteCategory(
                              category.id,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Welcome to Category Management!'));
        },
      ),
    );
  }
}
