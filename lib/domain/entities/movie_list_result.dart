import 'package:equatable/equatable.dart';
import 'package:flutter_template/domain/entities/movie.dart';

class MovieListResult extends Equatable {
  final List<Movie> movies;
  final int totalPages;
  final int currentPage;

  const MovieListResult({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [movies, totalPages, currentPage];
}
