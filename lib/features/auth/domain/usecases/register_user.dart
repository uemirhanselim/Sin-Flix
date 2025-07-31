import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class RegisterUser implements UseCase<UserEntity, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterUserParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterUserParams {
  final String name;
  final String email;
  final String password;

  RegisterUserParams({required this.name, required this.email, required this.password});
}
