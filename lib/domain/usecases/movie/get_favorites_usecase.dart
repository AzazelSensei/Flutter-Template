import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/domain/repositories/movie_repository.dart';

class GetFavoritesUseCase implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}
