import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/domain/entities/movie_list_result.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieListResult>> getMovieList({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<Movie>>> getFavorites();

  Future<Either<Failure, void>> toggleFavorite(String movieId);
}
