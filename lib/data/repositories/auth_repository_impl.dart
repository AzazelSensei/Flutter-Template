import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/storage/token_storage.dart';
import 'package:flutter_template/data/datasources/remote/auth_remote_datasource.dart';
import 'package:flutter_template/domain/entities/user.dart';
import 'package:flutter_template/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await remoteDataSource.login(
        email: email,
        password: password,
      );
      /*
       * NOT: Login başarılı olduğunda token'ı local storage'a kaydediyoruz.
       * Bu sayede kullanıcı uygulamayı yeniden açtığında tekrar login olmak zorunda kalmaz.
       */
      await tokenStorage.saveToken(token);
      return Right(token);
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      final token = await remoteDataSource.register(
        email: email,
        name: name,
        password: password,
      );
      /*
       * NOT: Kayıt başarılı olduğunda token'ı kaydedip kullanıcıyı direkt login ediyoruz.
       */
      await tokenStorage.saveToken(token);
      return Right(token);
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final userModel = await remoteDataSource.getProfile();
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfilePhoto(String photoPath) async {
    try {
      final userModel = await remoteDataSource.updateProfilePhoto(photoPath);
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenStorage.deleteToken();
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await tokenStorage.hasToken();
  }
}
