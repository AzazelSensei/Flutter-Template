import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/constants/app_constants.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/domain/usecases/movie/get_movie_list_usecase.dart';
import 'package:flutter_template/domain/usecases/movie/toggle_favorite_usecase.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieListUseCase getMovieListUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  MovieBloc({
    required this.getMovieListUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const MovieState()) {
    on<MovieLoadRequested>(_onLoadRequested);
    on<MovieLoadMore>(_onLoadMore);
    on<MovieRefresh>(_onRefresh);
    on<MovieToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadRequested(
    MovieLoadRequested event,
    Emitter<MovieState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MovieStatus.loading));

      final result = await getMovieListUseCase(
        GetMovieListParams(page: 1, limit: AppConstants.moviesPerPage),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: MovieStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (movieListResult) {
          final hasReachedMax = movieListResult.totalPages > 0
              ? movieListResult.currentPage >= movieListResult.totalPages
              : movieListResult.movies.length < AppConstants.moviesPerPage;

          final status = movieListResult.movies.isEmpty
              ? MovieStatus.empty
              : MovieStatus.success;

          emit(
            state.copyWith(
              status: status,
              movies: movieListResult.movies,
              currentPage: movieListResult.currentPage,
              totalPages: movieListResult.totalPages,
              hasReachedMax: hasReachedMax,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MovieStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    MovieLoadMore event,
    Emitter<MovieState> emit,
  ) async {
    try {
      /*
       * Guard: Duplicate request prevention
       * - Zaten son sayfadaysak yeni istek atma
       * - Şu anda yükleme yapılıyorsa duplicate istek atma
       */
      if (state.hasReachedMax || state.status == MovieStatus.loadingMore) return;

      emit(state.copyWith(status: MovieStatus.loadingMore));

      final nextPage = state.currentPage + 1;

      final result = await getMovieListUseCase(
        GetMovieListParams(page: nextPage, limit: AppConstants.moviesPerPage),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: MovieStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (movieListResult) {
          /*
           * Immutable list concatenation
           * List.of() ile yeni liste oluştur, cascade operator ile yeni filmleri ekle
           */
          final updatedMovies = List.of(state.movies)
            ..addAll(movieListResult.movies);

          final hasReachedMax = movieListResult.totalPages > 0
              ? nextPage >= movieListResult.totalPages
              : movieListResult.movies.length < AppConstants.moviesPerPage;

          emit(
            state.copyWith(
              status: MovieStatus.success,
              movies: updatedMovies,
              currentPage: nextPage, // NOT: API'den gelen değil local nextPage kullan (sync issue)
              totalPages: movieListResult.totalPages,
              hasReachedMax: hasReachedMax,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MovieStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(MovieRefresh event, Emitter<MovieState> emit) async {
    emit(const MovieState());
    add(const MovieLoadRequested());
  }

  Future<void> _onToggleFavorite(
    MovieToggleFavorite event,
    Emitter<MovieState> emit,
  ) async {
    try {
      final result = await toggleFavoriteUseCase(
        ToggleFavoriteParams(movieId: event.movieId),
      );

      result.fold(
        (failure) {
          // Hata durumunda UI'da geri bildirim verilmiyor (can be improved)
        },
        (_) {
          /*
           * Local state update: API başarılıysa listedeki filmin favori durumunu toggle et
           * Bu sayede kullanıcı anında UI değişikliğini görür
           */
          final updatedMovies = state.movies.map((movie) {
            if (movie.id == event.movieId) {
              return movie.copyWith(isFavorite: !movie.isFavorite);
            }
            return movie;
          }).toList();

          emit(state.copyWith(movies: updatedMovies));
        },
      );
    } catch (e) {
      // Catch silently - favorite toggle errors don't need to block UI
    }
  }
}
