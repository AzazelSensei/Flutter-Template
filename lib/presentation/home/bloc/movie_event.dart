part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class MovieLoadRequested extends MovieEvent {
  const MovieLoadRequested();
}

class MovieLoadMore extends MovieEvent {
  const MovieLoadMore();
}

class MovieRefresh extends MovieEvent {
  const MovieRefresh();
}

class MovieToggleFavorite extends MovieEvent {
  final String movieId;

  const MovieToggleFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
