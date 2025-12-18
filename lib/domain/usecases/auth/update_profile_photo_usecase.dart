import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/entities/user.dart';
import 'package:flutter_template/domain/repositories/auth_repository.dart';

class UpdateProfilePhotoUseCase implements UseCase<User, UpdateProfilePhotoParams> {
  final AuthRepository repository;

  UpdateProfilePhotoUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfilePhotoParams params) async {
    return await repository.updateProfilePhoto(params.photoPath);
  }
}

class UpdateProfilePhotoParams {
  final String photoPath;

  UpdateProfilePhotoParams({required this.photoPath});
}
