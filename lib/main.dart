import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:team1/features/auth1/data/datasource/auth_api_service.dart';
import 'package:team1/features/auth1/data/repositories/auth_repository_impl.dart';
import 'package:team1/features/auth1/presentation/bloc/auth_cubit.dart';

import 'package:team1/features/category_management/presentation/cubit/category_cubit.dart';
import 'package:team1/features/product_management/presentation/cubit/product_cubit.dart';

import 'package:team1/screen/AnimatedNavExample.dart';
import 'package:team1/splash.dart';
import 'features/auth1/domain/use_cases/login_user.dart';
import 'features/auth1/domain/use_cases/register_user.dart';

import 'package:team1/features/product_management/data/datasources/product_api_service.dart';
import 'package:team1/features/product_management/data/repositories/product_repository_impl.dart';
import 'package:team1/features/product_management/domain/use_cases/create_product.dart';
import 'package:team1/features/product_management/domain/use_cases/delete_product.dart';
import 'package:team1/features/product_management/domain/use_cases/get_all_products.dart';
import 'package:team1/features/product_management/domain/use_cases/update_product.dart';

import 'package:team1/features/category_management/data/datasources/category_api_service.dart';
import 'package:team1/features/category_management/data/repositories/category_repository_impl.dart';
import 'package:team1/features/category_management/domain/use_cases/create_category.dart';
import 'package:team1/features/category_management/domain/use_cases/delete_category.dart';
import 'package:team1/features/category_management/domain/use_cases/get_all_categories.dart';
import 'package:team1/features/category_management/domain/use_cases/update_category.dart';

// Auth Dependencies
final authApiService = AuthApiService();
final authRepository = AuthRepositoryImpl(authApiService);
final loginUser = LoginUser(authRepository);
final registerUser = RegisterUser(authRepository);

// Product Management Dependencies
final productApiService = ProductApiService();
final productRepository = ProductRepositoryImpl(productApiService);
final getAllProducts = GetAllProducts(productRepository);
final createProduct = CreateProduct(productRepository);
final updateProduct = UpdateProduct(productRepository);
final deleteProduct = DeleteProduct(productRepository);

// Category Management Dependencies
final categoryApiService = CategoryApiService();
final categoryRepository = CategoryRepositoryImpl(categoryApiService);
final getAllCategories = GetAllCategories(categoryRepository);
final createCategory = CreateCategory(categoryRepository);
final updateCategory = UpdateCategory(categoryRepository);
final deleteCategory = DeleteCategory(categoryRepository);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(loginUser, registerUser),
          ),
          BlocProvider<CategoryCubit>(
            create: (_) => CategoryCubit(
              getAllCategories,
              createCategory,
              updateCategory,
              deleteCategory,
            ),
          ),
          BlocProvider<ProductCubit>(
            create: (_) => ProductCubit(
              getAllProducts,
              createProduct,
              updateProduct,
              deleteProduct,
            ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 مهم جداً لدعم الترجمة
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home:Splash(),
    );
  }
}
