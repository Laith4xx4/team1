import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/product_management/presentation/cubit/product_cubit.dart';
import 'package:team1/features/product_management/presentation/cubit/product_state.dart';

const String _baseImageUrl = 'http://192.168.100.66:5086/';

class Glass extends StatefulWidget {
  const Glass({super.key});

  @override
  State<Glass> createState() => _GlassState();
}

class _GlassState extends State<Glass> {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is ProductActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return const Center(child: Text('No products to display.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
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
                            color: Colors.black,
                          ),
                        ),

                        subtitle: Text(
                          "Price: \$${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),

                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No products to display.'));
        },
      );
    }
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
          : const Icon(Icons.image_not_supported, color: Colors.white);
    }


