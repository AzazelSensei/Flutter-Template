import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/entities/user.dart';
import 'package:flutter_template/domain/repositories/auth_repository.dart';

class GetProfileUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getProfile();
  }
}
