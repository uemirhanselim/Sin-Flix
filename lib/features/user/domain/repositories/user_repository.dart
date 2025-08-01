import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> uploadPhoto({required File photo});
  Future<Either<Failure, UserEntity>> getUserProfile();
}
