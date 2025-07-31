import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUser implements UseCase<UserEntity, LoginUserParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginUserParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginUserParams {
  final String email;
  final String password;

  LoginUserParams({required this.email, required this.password});
}
