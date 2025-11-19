import 'package:team1/features/auth1/data/datasource/auth_api_service.dart';
import 'package:team1/features/auth1/domain/entities/user.dart';
import 'package:team1/features/auth1/domain/repositories/auth_repository.dart';
import 'package:team1/features/auth1/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final Map<String, dynamic> responseData = await remoteDataSource.login(
      email,
      password,
    );
    // Assuming the API returns 'id', 'email', 'role', 'token'
    return UserModel(
      id:
          responseData['id'] ??
          '', // Provide a default or handle null appropriately
      email: email,
      role: responseData['role'] ?? 'user',
      token: responseData['token'],
    );
  }

  @override
  Future<User> register(String email, String password, String role) async {
    final Map<String, dynamic> responseData = await remoteDataSource.register(
      email,
      password,
      role,
    );
    // For register, assuming minimal info returned, might need to fetch user details or infer
    return UserModel(
      id: responseData['id'] ?? '', // Placeholder, might need a real ID from API or generate one
      email: email,
      role: responseData['role'] ?? role,
      token: responseData['token'], // Might be null for registration
    );
  }
}
