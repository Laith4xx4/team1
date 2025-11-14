import 'package:team1/features/auth1/domain/entities/user.dart';
import 'package:team1/features/auth1/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<User> call(String email, String password, String role) {
    return repository.register(email, password, role);
  }
}
