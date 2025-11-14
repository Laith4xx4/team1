import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/product_management/domain/entities/product.dart';
import 'package:team1/features/product_management/presentation/cubit/product_cubit.dart';
import 'package:team1/features/product_management/presentation/cubit/product_state.dart';
import 'package:team1/features/product_management/presentation/pages/product_listing_screen.dart';

const String _baseImageUrl = 'http://192.168.100.66:5086/';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

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
    return Scaffold(

  appBar:
        AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  // افتح القائمة الجانبية
                },
              ),
            ),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'موقعك',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'ecommerce',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    // البحث
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 4.0),
              child: Container(

                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    // عربة التسوق
                  },
                ),
              ),
            ),
          ],
        ),



  body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is ProductActionSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            products = state.products;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 🟦 Banner Slider
                  CarouselSlider(
                    items: products.map((product) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductListingScreen(),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // عرض الصور المحلية أو من السيرفر
                              product.mainImageUrl != null &&
                                  product.mainImageUrl!.startsWith('file://')
                                  ? Image.file(
                                File(product.mainImageUrl!
                                    .replaceFirst('file://', '')),
                                fit: BoxFit.cover,
                              )
                                  : (product.mainImageUrl != null
                                  ? Image.network(
                                _baseImageUrl + product.mainImageUrl!,
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.image_not_supported,
                                  size: 50)),
                              // اسم المنتج
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  color: Colors.black54,
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // الدائرة الحمراء أسفل السلايدر
                  Container(
                    width: screenWidth * 0.35,
                    height: screenWidth * 0.35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/rt.png",
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'ecommerce',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },

    ),
    );
  }
}
