import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/data/datasources/movie_remote_data_source.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/domain/entities/movie_list_result.dart';
import 'package:flutter_template/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MovieListResult>> getMovieList({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await remoteDataSource.getMovieList(
        page: page,
        limit: limit,
      );
      /*
       * NOT: MovieModel'leri domain entity'sine çeviriyoruz.
       * Bu Clean Architecture prensibine uygun olarak data layer'ın
       * domain layer'dan bağımsız kalmasını sağlar.
       */
      final movies = response.movies.map((model) => model.toEntity()).toList();
      final result = MovieListResult(
        movies: movies,
        totalPages: response.totalPages,
        currentPage: response.currentPage,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async {
    try {
      final movieModels = await remoteDataSource.getFavorites();
      final movies = movieModels.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String movieId) async {
    try {
      await remoteDataSource.toggleFavorite(movieId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
