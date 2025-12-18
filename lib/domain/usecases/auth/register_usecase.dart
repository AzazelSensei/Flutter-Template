import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<String, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      name: params.name,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String name;
  final String password;

  const RegisterParams({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [email, name, password];
}
