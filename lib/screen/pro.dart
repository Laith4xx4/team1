import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../features/product_management/presentation/cubit/product_cubit.dart';
import '../features/product_management/presentation/cubit/product_state.dart';


const String _baseImageUrl =
    'http://192.168.100.66:5086/'; // Define your base image URL here

class Pro extends StatefulWidget {
  final int categoryId;
    const Pro({super.key,required this.categoryId});

  @override
  State<Pro> createState() => _ProState();
}

class _ProState extends State<Pro> {
  @override
  @override
  void initState() {
    super.initState();


    context.read<ProductCubit>().loadProductsByCategory(widget.categoryId);
  }
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: Colors.white,
        lightSource: LightSource.topLeft,
        depth: 8,
      ),
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: NeumorphicAppBar(
          title: const Text(
            'Product Management',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
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
              final products = state.products;

              if (products.isEmpty) {
                return const Center(child: Text('No products to display.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 8,
                        intensity: 0.8,
                        surfaceIntensity: 0.2,
                        boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                        color: Color(0xFF129AA6),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 55,
                            height: 55,
                            child: _buildProductImage(product),
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Price: \$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        // trailing: IconButton(
                        //   icon: const Icon(Icons.delete, color: Colors.redAccent),
                        //   onPressed: () {
                        //     context.read<ProductCubit>().deleteProduct(product.id);
                        //   },
                        // ),
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
      ),
    );
  }

  Widget _buildProductImage(product) {
    if (product.mainImageUrl != null &&
        product.mainImageUrl!.startsWith('file://')) {
      return Image.file(
        File(product.mainImageUrl!.replaceFirst('file://', '')),
        fit: BoxFit.cover,
      );
    }

    return product.mainImageUrl != null
        ? Image.network(
      _baseImageUrl + product.mainImageUrl!,
      fit: BoxFit.cover,
    )
        : const Icon(Icons.image_not_supported, color: Colors.black45);
  }
}
