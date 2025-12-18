import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/repositories/movie_repository.dart';

class ToggleFavoriteUseCase implements UseCase<void, ToggleFavoriteParams> {
  final MovieRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(params.movieId);
  }
}

class ToggleFavoriteParams extends Equatable {
  final String movieId;

  const ToggleFavoriteParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
