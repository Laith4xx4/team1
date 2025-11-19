
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/product_management/presentation/cubit/product_cubit.dart';

import '../cubit/product_state.dart';
import '../pages/product_listing_screen.dart';

const String _baseImageUrl = 'http://192.168.100.66:5086/';
class Carousl extends StatefulWidget {
  const Carousl({super.key});

  @override
  State<Carousl> createState() => _CarouslState();
}

class _CarouslState extends State<Carousl> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is ProductLoaded) {
          final products = state.products;
          return CarouselSlider(
            items: products.map((product) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (
                        _) => const ProductListingScreen()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      product.mainImageUrl != null && product.mainImageUrl!
                          .startsWith('file://')
                          ? Image.file(File(
                          product.mainImageUrl!.replaceFirst('file://', '')),
                          fit: BoxFit.cover)
                          : (product.mainImageUrl != null
                          ? Image.network(_baseImageUrl + product.mainImageUrl!,
                          fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported, size: 50)),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: Colors.black54,
                          child: Text(product.name,
                              style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: screenHeight * 0.25,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
