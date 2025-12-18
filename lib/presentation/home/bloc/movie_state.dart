part of 'movie_bloc.dart';

enum MovieStatus { initial, loading, loadingMore, success, empty, failure }

class MovieState extends Equatable {
  final MovieStatus status;
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  const MovieState({
    this.status = MovieStatus.initial,
    this.movies = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.totalPages = 0,
    this.errorMessage,
  });

  MovieState copyWith({
    MovieStatus? status,
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movies, hasReachedMax, currentPage, totalPages, errorMessage];
}
