import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> register({
    required String email,
    required String name,
    required String password,
  });

  Future<Either<Failure, User>> getProfile();

  Future<Either<Failure, User>> updateProfilePhoto(String photoPath);

  Future<Either<Failure, void>> logout();

  Future<bool> isAuthenticated();
}
