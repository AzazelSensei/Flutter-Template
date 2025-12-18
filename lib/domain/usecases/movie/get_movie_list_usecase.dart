import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/core/error/failures.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/domain/entities/movie_list_result.dart';
import 'package:flutter_template/domain/repositories/movie_repository.dart';

class GetMovieListUseCase implements UseCase<MovieListResult, GetMovieListParams> {
  final MovieRepository repository;

  GetMovieListUseCase(this.repository);

  @override
  Future<Either<Failure, MovieListResult>> call(GetMovieListParams params) async {
    return await repository.getMovieList(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMovieListParams extends Equatable {
  final int page;
  final int limit;

  const GetMovieListParams({
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [page, limit];
}
