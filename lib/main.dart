import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/auth1/data/datasource/auth_api_service.dart';
import 'package:team1/features/auth1/data/repositories/auth_repository_impl.dart';
import 'package:team1/features/auth1/presentation/bloc/auth_cubit.dart';
import 'package:team1/splash.dart';

import 'features/auth1/domain/use_cases/login_user.dart';
import 'features/auth1/domain/use_cases/register_user.dart';

// Setup dependencies
final authApiService = AuthApiService();
final authRepository = AuthRepositoryImpl(authApiService);
final loginUser = LoginUser(authRepository);
final registerUser = RegisterUser(authRepository);

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(loginUser, registerUser),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Splash(),
    );
  }
}
